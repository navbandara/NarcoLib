#!/usr/bin/env python3
"""
Dataset Splitting Script for NarcoLib Machine-Learning Project.

This script splits the verified images into training (70%), validation (15%),
and testing (15%) sets. It uses a fixed random seed (42) and ensures that
duplicate files (identical SHA-256 hashes) never cross split boundaries.
"""

import argparse
import csv
import hashlib
import random
import shutil
from pathlib import Path
from typing import Dict, List, Set, Tuple, Optional
from PIL import Image

# Supported image extensions (case-insensitive)
SUPPORTED_EXTENSIONS = {'.jpg', '.jpeg', '.png', '.bmp', '.webp'}

# Mapping from source class folders to output class folders
CLASS_NAME_MAPPING = {
    "Magic mushroom": "Magic mashroom",
    "Magic mashroom": "Magic mashroom"
}

def map_class_name(name: str) -> str:
    """Map source class folder name to the required output folder name."""
    return CLASS_NAME_MAPPING.get(name, name)

def compute_sha256(file_path: Path) -> str:
    """Compute the SHA-256 hash of a file in chunks to optimize memory."""
    sha256 = hashlib.sha256()
    try:
        with open(file_path, "rb") as f:
            for chunk in iter(lambda: f.read(65536), b""):
                sha256.update(chunk)
    except Exception as e:
        raise OSError(f"Failed to read file for hashing: {e}")
    return sha256.hexdigest()

def is_image_readable(file_path: Path) -> Tuple[bool, Optional[str]]:
    """
    Check if an image file is readable using Pillow.
    
    Returns:
        Tuple[bool, Optional[str]]: (is_readable, error_message)
    """
    try:
        with Image.open(file_path) as img:
            img.verify()
        with Image.open(file_path) as img:
            img.load()
            return True, None
    except Exception as e:
        return False, str(e)

def main():
    parser = argparse.ArgumentParser(description="Split NarcoLib Dataset into Train/Val/Test Splits")
    parser.add_argument(
        "--dataset-dir",
        type=str,
        default=r"E:\project\narcolib_app\dataset",
        help="Path to the source dataset directory"
    )
    parser.add_argument(
        "--output-dir",
        type=str,
        default=r"E:\project\narcolib_app\machine_learning\data_split",
        help="Path to the split dataset output directory"
    )
    parser.add_argument(
        "--reports-dir",
        type=str,
        default=r"E:\project\narcolib_app\machine_learning\reports",
        help="Directory to save generated CSV reports"
    )
    
    args = parser.parse_args()
    
    dataset_path = Path(args.dataset_dir)
    output_path = Path(args.output_dir)
    reports_path = Path(args.reports_dir)
    
    print(f"Source dataset path: {dataset_path}")
    print(f"Output folder path:  {output_path}")
    print(f"Reports folder path: {reports_path}")
    
    # Set fixed random seed for reproducibility
    random.seed(42)
    
    # Verify dataset existence
    if not dataset_path.exists():
        print(f"Error: Source dataset directory '{dataset_path}' does not exist.")
        return
    if not dataset_path.is_dir():
        print(f"Error: '{dataset_path}' is not a directory.")
        return
        
    # Ensure reports and output directories exist
    reports_path.mkdir(parents=True, exist_ok=True)
    output_path.mkdir(parents=True, exist_ok=True)
    
    # Discover class directories
    class_dirs = sorted([
        d for d in dataset_path.iterdir()
        if d.is_dir() and not d.name.startswith('.')
    ])
    
    if not class_dirs:
        print("Warning: No class directories found in the source dataset path.")
        return

    # Data collection structures
    skipped_files: List[Dict] = []
    
    # Map hash -> List of (class_name, file_path)
    hash_to_files: Dict[str, List[Tuple[str, Path]]] = {}
    
    # Map class_name -> list of hashes present in that class
    class_to_hashes: Dict[str, Set[str]] = {
        map_class_name(d.name): set() for d in class_dirs
    }
    
    # Set to keep track of target classes list
    target_classes = sorted(list(class_to_hashes.keys()))
    
    print("\nScanning source dataset and calculating hashes...")
    for class_dir in class_dirs:
        source_class_name = class_dir.name
        target_class_name = map_class_name(source_class_name)
        
        print(f"  Scanning class: '{source_class_name}' (mapping to '{target_class_name}')...")
        
        # Discover files recursively, sort them to ensure OS-independent consistency
        file_paths = sorted(list(class_dir.rglob('*')))
        
        for file_path in file_paths:
            if not file_path.is_file():
                continue
                
            # Check file extension
            ext = file_path.suffix.lower()
            if ext not in SUPPORTED_EXTENSIONS:
                continue
                
            # Verify file integrity
            is_valid, error_msg = is_image_readable(file_path)
            if not is_valid:
                skipped_files.append({
                    "class_name": target_class_name,
                    "filename": file_path.name,
                    "full_path": str(file_path.resolve()),
                    "error_message": error_msg or "Failed to load/verify image data"
                })
                continue
                
            # Compute hash
            try:
                file_hash = compute_sha256(file_path)
            except Exception as e:
                skipped_files.append({
                    "class_name": target_class_name,
                    "filename": file_path.name,
                    "full_path": str(file_path.resolve()),
                    "error_message": f"Hash computation failed: {e}"
                })
                continue
                
            # Group by hash
            if file_hash not in hash_to_files:
                hash_to_files[file_hash] = []
            hash_to_files[file_hash].append((target_class_name, file_path))
            class_to_hashes[target_class_name].add(file_hash)

    # Determine splitting allocation
    # To prevent data leakage, a hash must be assigned to exactly one split globally
    # hash_to_split: Dict[str, str] (hash -> "train" | "validation" | "test")
    hash_to_split: Dict[str, str] = {}
    
    # Class-level counters for splits
    # class_name -> { "train": 0, "validation": 0, "test": 0, "total_valid": 0 }
    class_split_stats: Dict[str, Dict[str, int]] = {
        cls_name: {"train": 0, "validation": 0, "test": 0, "total_valid": 0}
        for cls_name in target_classes
    }
    
    # Sort hashes globally to ensure deterministic order before shuffling
    sorted_unique_hashes = sorted(list(hash_to_files.keys()))
    
    # First, let's determine the counts of valid images per class
    for h in sorted_unique_hashes:
        for target_cls, _ in hash_to_files[h]:
            class_split_stats[target_cls]["total_valid"] += 1
            
    print("\nAllocating image files to splits...")
    
    # To split stratifiably, we process class-by-class
    for cls_name in target_classes:
        # Get all hashes in this class
        cls_hashes = class_to_hashes[cls_name]
        
        # Filter into already assigned and unassigned hashes
        already_assigned = sorted([h for h in cls_hashes if h in hash_to_split])
        unassigned = sorted([h for h in cls_hashes if h not in hash_to_split])
        
        # Update current split counts for this class based on already assigned hashes
        for h in already_assigned:
            split_name = hash_to_split[h]
            # Count files in this class for this hash
            count_in_cls = sum(1 for c, _ in hash_to_files[h] if c == cls_name)
            class_split_stats[cls_name][split_name] += count_in_cls
            
        # Target counts for this class (70% train, 15% validation, 15% test)
        total_in_cls = class_split_stats[cls_name]["total_valid"]
        target_train = round(0.70 * total_in_cls)
        target_val = round(0.15 * total_in_cls)
        target_test = total_in_cls - target_train - target_val
        
        # Shuffle unassigned hashes with random seed
        random.shuffle(unassigned)
        
        # Distribute unassigned hashes to fill the deficits
        for h in unassigned:
            # How many files of this hash in this class?
            count_in_cls = sum(1 for c, _ in hash_to_files[h] if c == cls_name)
            
            # Calculate current deficits
            deficit_train = target_train - class_split_stats[cls_name]["train"]
            deficit_val = target_val - class_split_stats[cls_name]["validation"]
            deficit_test = target_test - class_split_stats[cls_name]["test"]
            
            # Choose the split with the maximum deficit, breaking ties deterministically
            deficits = [
                (deficit_train, "train"),
                (deficit_val, "validation"),
                (deficit_test, "test")
            ]
            deficits.sort(key=lambda x: (x[0], -("train", "validation", "test").index(x[1])), reverse=True)
            chosen_split = deficits[0][1]
            
            # Record global assignment
            hash_to_split[h] = chosen_split
            
            # Update counts for all classes containing this hash
            for other_cls, _ in hash_to_files[h]:
                count_in_other = sum(1 for c, _ in hash_to_files[h] if c == other_cls)
                class_split_stats[other_cls][chosen_split] += count_in_other

    # Create directories for splits
    for split in ["train", "validation", "test"]:
        for cls_name in target_classes:
            (output_path / split / cls_name).mkdir(parents=True, exist_ok=True)
            
    # List of manifest entries for split_file_manifest.csv
    manifest_entries: List[Dict] = []
    
    print("\nCopying files to split directories...")
    # Copy files
    for h, file_entries in hash_to_files.items():
        split_name = hash_to_split[h]
        for target_cls, src_path in file_entries:
            # Preserving subdirectories if they exist in source
            # Find path relative to dataset_dir/original_class_name
            # First find the parent directory directly under dataset_dir
            source_class_dir = dataset_path / src_path.relative_to(dataset_path).parts[0]
            rel_path = src_path.relative_to(source_class_dir)
            
            dst_path = output_path / split_name / target_cls / rel_path
            
            # Ensure target parent exists (in case of nested subfolders)
            dst_path.parent.mkdir(parents=True, exist_ok=True)
            
            try:
                shutil.copy2(src_path, dst_path)
                manifest_entries.append({
                    "class_name": target_cls,
                    "original_path": str(src_path.resolve()),
                    "copied_path": str(dst_path.resolve()),
                    "split_name": split_name,
                    "sha256_hash": h
                })
            except Exception as e:
                print(f"Error copying file from {src_path} to {dst_path}: {e}")
                
    print("\nVerifying data split for leaks...")
    # Verify no hash overlap between output directories (data leakage verification)
    split_hashes: Dict[str, Set[str]] = {"train": set(), "validation": set(), "test": set()}
    for entry in manifest_entries:
        split_hashes[entry["split_name"]].add(entry["sha256_hash"])
        
    overlap_train_val = split_hashes["train"].intersection(split_hashes["validation"])
    overlap_train_test = split_hashes["train"].intersection(split_hashes["test"])
    overlap_val_test = split_hashes["validation"].intersection(split_hashes["test"])
    
    if overlap_train_val or overlap_train_test or overlap_val_test:
        error_msg = (
            f"DATA LEAKAGE DETECTED across splits!\n"
            f"Overlapping hashes found:\n"
            f"  Train & Validation overlap: {len(overlap_train_val)}\n"
            f"  Train & Test overlap:       {len(overlap_train_test)}\n"
            f"  Validation & Test overlap:  {len(overlap_val_test)}"
        )
        # Delete output directories to prevent usage of a corrupted split
        print(f"CRITICAL ERROR: {error_msg}")
        raise ValueError(error_msg)
    else:
        print("Verification SUCCESS: 0 data leaks detected. Hash separation is completely clean.")

    # Write CSV Reports (always write headers even if empty)
    
    # 1. split_summary.csv
    summary_csv_path = reports_path / "split_summary.csv"
    try:
        with open(summary_csv_path, "w", newline="", encoding="utf-8") as f:
            writer = csv.writer(f)
            writer.writerow(["class_name", "original_valid_image_count", "training_count", "validation_count", "test_count"])
            for cls_name in target_classes:
                stats = class_split_stats[cls_name]
                writer.writerow([
                    cls_name,
                    stats["total_valid"],
                    stats["train"],
                    stats["validation"],
                    stats["test"]
                ])
    except Exception as e:
        print(f"Error writing to {summary_csv_path}: {e}")

    # 2. split_file_manifest.csv
    manifest_csv_path = reports_path / "split_file_manifest.csv"
    try:
        with open(manifest_csv_path, "w", newline="", encoding="utf-8") as f:
            writer = csv.writer(f)
            writer.writerow(["class_name", "original_path", "copied_path", "split_name", "sha256_hash"])
            for entry in manifest_entries:
                writer.writerow([
                    entry["class_name"],
                    entry["original_path"],
                    entry["copied_path"],
                    entry["split_name"],
                    entry["sha256_hash"]
                ])
    except Exception as e:
        print(f"Error writing to {manifest_csv_path}: {e}")

    # 3. skipped_split_files.csv
    skipped_csv_path = reports_path / "skipped_split_files.csv"
    try:
        with open(skipped_csv_path, "w", newline="", encoding="utf-8") as f:
            writer = csv.writer(f)
            writer.writerow(["class_name", "filename", "full_path", "error_message"])
            for item in skipped_files:
                writer.writerow([
                    item["class_name"],
                    item["filename"],
                    item["full_path"],
                    item["error_message"]
                ])
    except Exception as e:
        print(f"Error writing to {skipped_csv_path}: {e}")

    # Print the terminal summary showing counts for every class and split
    print("\n" + "=" * 65)
    print("                      DATASET SPLITTING SUMMARY")
    print("=" * 65)
    print(f"  {'Class Name':<22} | {'Original':<8} | {'Train':<7} | {'Val':<7} | {'Test':<7}")
    print(f"  {'-'*22}-+-{'-'*8}-+-{'-'*7}-+-{'-'*7}-+-{'-'*7}")
    
    total_original = 0
    total_train = 0
    total_val = 0
    total_test = 0
    
    for cls_name in target_classes:
        stats = class_split_stats[cls_name]
        total_original += stats["total_valid"]
        total_train += stats["train"]
        total_val += stats["validation"]
        total_test += stats["test"]
        
        print(f"  {cls_name:<22} | {stats['total_valid']:<8} | {stats['train']:<7} | {stats['validation']:<7} | {stats['test']:<7}")
        
    print(f"  {'-'*22}-+-{'-'*8}-+-{'-'*7}-+-{'-'*7}-+-{'-'*7}")
    print(f"  {'Total':<22} | {total_original:<8} | {total_train:<7} | {total_val:<7} | {total_test:<7}")
    print("=" * 65)
    print(f"Skipped/Corrupt Files:   {len(skipped_files)}")
    print(f"Reports Generated successfully:")
    print(f"  - Summary:    {summary_csv_path.name}")
    print(f"  - Manifest:   {manifest_csv_path.name}")
    print(f"  - Skipped:    {skipped_csv_path.name}")
    print(f"Reports Location: {reports_path.resolve()}")
    print("=" * 65 + "\n")

if __name__ == "__main__":
    main()
