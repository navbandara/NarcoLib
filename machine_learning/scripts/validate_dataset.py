#!/usr/bin/env python3
"""
Dataset Validation Script for NarcoLib Machine-Learning Project.

This script scans the dataset directory recursively, validates each image using Pillow,
computes SHA-256 hashes to detect duplicate files, and outputs detailed reports in CSV format.
"""

import argparse
import csv
import hashlib
from pathlib import Path
from typing import Dict, List, Tuple, Optional
from PIL import Image

# Supported image extensions (case-insensitive)
SUPPORTED_EXTENSIONS = {'.jpg', '.jpeg', '.png', '.bmp', '.webp'}

def compute_sha256(file_path: Path) -> str:
    """
    Compute the SHA-256 hash of a file in chunks to optimize memory usage.
    
    Args:
        file_path (Path): Path to the file.
        
    Returns:
        str: Hexadecimal SHA-256 hash of the file.
    """
    sha256 = hashlib.sha256()
    try:
        with open(file_path, "rb") as f:
            for chunk in iter(lambda: f.read(65536), b""):
                sha256.update(chunk)
    except Exception as e:
        raise OSError(f"Failed to read file for hashing: {e}")
    return sha256.hexdigest()

def validate_image_file(file_path: Path) -> Tuple[bool, Optional[str], Optional[int], Optional[int]]:
    """
    Validate if an image file is readable and not corrupt using Pillow.
    
    Args:
        file_path (Path): Path to the image file.
        
    Returns:
        Tuple[bool, Optional[str], Optional[int], Optional[int]]:
            - bool: True if the image is valid and readable, False otherwise.
            - Optional[str]: Error message if invalid, None if valid.
            - Optional[int]: Width in pixels if valid, None if invalid.
            - Optional[int]: Height in pixels if valid, None if invalid.
    """
    try:
        # First verify the container / file headers
        with Image.open(file_path) as img:
            img.verify()
        
        # Open again to load pixel data and detect corruption in data stream
        with Image.open(file_path) as img:
            img.load()
            width, height = img.size
            return True, None, width, height
    except Exception as e:
        return False, str(e), None, None

def main():
    # Set up argument parsing to allow flexibility in dataset and reports directory paths
    parser = argparse.ArgumentParser(description="Validate NarcoLib Image Dataset")
    parser.add_argument(
        "--dataset-dir",
        type=str,
        default=r"E:\project\narcolib_app\dataset",
        help="Path to the dataset directory (default: E:\\project\\narcolib_app\\dataset)"
    )
    parser.add_argument(
        "--reports-dir",
        type=str,
        default=r"E:\project\narcolib_app\machine_learning\reports",
        help="Directory to save generated CSV reports (default: E:\\project\\narcolib_app\\machine_learning\\reports)"
    )
    
    args = parser.parse_args()
    
    dataset_path = Path(args.dataset_dir)
    reports_path = Path(args.reports_dir)
    
    print(f"Dataset path: {dataset_path}")
    print(f"Reports path: {reports_path}")
    
    # Verify dataset directory existence
    if not dataset_path.exists():
        print(f"Error: Dataset directory '{dataset_path}' does not exist.")
        return
    if not dataset_path.is_dir():
        print(f"Error: '{dataset_path}' is not a directory.")
        return
        
    # Ensure reports directory exists
    reports_path.mkdir(parents=True, exist_ok=True)
    
    # Discover class folders (subdirectories directly under the dataset path)
    # Ignore hidden directories (e.g., those starting with a dot)
    class_dirs = sorted([
        d for d in dataset_path.iterdir() 
        if d.is_dir() and not d.name.startswith('.')
    ])
    
    if not class_dirs:
        print("Warning: No class directories found inside the dataset path.")
        
    # Data structures to collect details
    valid_images: List[Dict] = []
    corrupt_images: List[Dict] = []
    duplicate_images: List[Dict] = []
    
    # Dictionary mapping SHA-256 hash -> file Path
    seen_hashes: Dict[str, Path] = {}
    
    # Class-level statistics
    # class_name -> { "total": 0, "valid": 0, "corrupt": 0, "duplicates": 0 }
    class_stats: Dict[str, Dict[str, int]] = {
        d.name: {"total": 0, "valid": 0, "corrupt": 0, "duplicates": 0}
        for d in class_dirs
    }
    
    print("\nScanning dataset classes recursively...")
    
    for class_dir in class_dirs:
        class_name = class_dir.name
        print(f"  Processing class: '{class_name}'...")
        
        # Recursively search for files in the class folder
        for file_path in class_dir.rglob('*'):
            if not file_path.is_file():
                continue
                
            # Filter by supported extensions (case-insensitive)
            ext = file_path.suffix.lower()
            if ext not in SUPPORTED_EXTENSIONS:
                continue
                
            class_stats[class_name]["total"] += 1
            
            # Compute file hash
            try:
                file_hash = compute_sha256(file_path)
            except Exception as e:
                # If we cannot read/hash the file, it is considered unreadable / corrupt
                class_stats[class_name]["corrupt"] += 1
                corrupt_images.append({
                    "class_name": class_name,
                    "filename": file_path.name,
                    "full_path": str(file_path.resolve()),
                    "error_message": f"Hash computation failed: {e}"
                })
                continue
                
            # Validate image readability & integrity using Pillow
            is_valid, error_msg, width, height = validate_image_file(file_path)
            
            if not is_valid:
                class_stats[class_name]["corrupt"] += 1
                corrupt_images.append({
                    "class_name": class_name,
                    "filename": file_path.name,
                    "full_path": str(file_path.resolve()),
                    "error_message": error_msg or "Failed to load/verify image data"
                })
                continue
                
            # At this point, the image is valid
            class_stats[class_name]["valid"] += 1
            file_size = file_path.stat().st_size
            aspect_ratio = round(width / height, 4) if height and height > 0 else 0.0
            
            valid_images.append({
                "class_name": class_name,
                "filename": file_path.name,
                "full_path": str(file_path.resolve()),
                "file_extension": ext,
                "width": width,
                "height": height,
                "aspect_ratio": aspect_ratio,
                "file_size_bytes": file_size
            })
            
            # Duplicate detection
            if file_hash in seen_hashes:
                class_stats[class_name]["duplicates"] += 1
                duplicate_images.append({
                    "sha256_hash": file_hash,
                    "class_name": class_name,
                    "filename": file_path.name,
                    "full_path": str(file_path.resolve()),
                    "original_path": str(seen_hashes[file_hash].resolve())
                })
            else:
                seen_hashes[file_hash] = file_path

    # Compute terminal stats
    total_classes = len(class_dirs)
    total_valid = len(valid_images)
    total_corrupt = len(corrupt_images)
    total_duplicates = len(duplicate_images)
    
    # Calculate min, max, average dimensions
    widths = [img["width"] for img in valid_images if img["width"] is not None]
    heights = [img["height"] for img in valid_images if img["height"] is not None]
    
    min_width = min(widths) if widths else 0
    max_width = max(widths) if widths else 0
    avg_width = sum(widths) / len(widths) if widths else 0.0
    
    min_height = min(heights) if heights else 0
    max_height = max(heights) if heights else 0
    avg_height = sum(heights) / len(heights) if heights else 0.0
    
    # Class imbalance ratio calculation (ratio of max valid count to min valid count)
    valid_counts = [stats["valid"] for stats in class_stats.values()]
    if valid_counts:
        max_valid = max(valid_counts)
        min_valid = min(valid_counts)
        imbalance_ratio = max_valid / min_valid if min_valid > 0 else float('inf')
    else:
        imbalance_ratio = 0.0

    # Write reports (always write headers even if no rows)
    
    # 1. dataset_summary.csv
    summary_path = reports_path / "dataset_summary.csv"
    try:
        with open(summary_path, "w", newline="", encoding="utf-8") as f:
            writer = csv.writer(f)
            writer.writerow(["class_name", "total_images", "valid_images", "corrupt_images", "duplicate_images"])
            for cls_name, stats in class_stats.items():
                writer.writerow([
                    cls_name,
                    stats["total"],
                    stats["valid"],
                    stats["corrupt"],
                    stats["duplicates"]
                ])
    except Exception as e:
        print(f"Error writing report to {summary_path}: {e}")
        
    # 2. image_details.csv
    details_path = reports_path / "image_details.csv"
    try:
        with open(details_path, "w", newline="", encoding="utf-8") as f:
            writer = csv.writer(f)
            writer.writerow([
                "class_name", "filename", "full_path", "file_extension", 
                "width", "height", "aspect_ratio", "file_size_bytes"
            ])
            for img in valid_images:
                writer.writerow([
                    img["class_name"],
                    img["filename"],
                    img["full_path"],
                    img["file_extension"],
                    img["width"],
                    img["height"],
                    img["aspect_ratio"],
                    img["file_size_bytes"]
                ])
    except Exception as e:
        print(f"Error writing report to {details_path}: {e}")
        
    # 3. corrupt_images.csv
    corrupt_path = reports_path / "corrupt_images.csv"
    try:
        with open(corrupt_path, "w", newline="", encoding="utf-8") as f:
            writer = csv.writer(f)
            writer.writerow(["class_name", "filename", "full_path", "error_message"])
            for img in corrupt_images:
                writer.writerow([
                    img["class_name"],
                    img["filename"],
                    img["full_path"],
                    img["error_message"]
                ])
    except Exception as e:
        print(f"Error writing report to {corrupt_path}: {e}")
        
    # 4. duplicate_images.csv
    duplicate_path = reports_path / "duplicate_images.csv"
    try:
        with open(duplicate_path, "w", newline="", encoding="utf-8") as f:
            writer = csv.writer(f)
            writer.writerow(["sha256_hash", "class_name", "filename", "full_path", "original_path"])
            for img in duplicate_images:
                writer.writerow([
                    img["sha256_hash"],
                    img["class_name"],
                    img["filename"],
                    img["full_path"],
                    img["original_path"]
                ])
    except Exception as e:
        print(f"Error writing report to {duplicate_path}: {e}")
        
    # Print the readable terminal summary
    print("\n" + "=" * 65)
    print("                     DATASET VALIDATION SUMMARY")
    print("=" * 65)
    print(f"Total Classes Scanned:    {total_classes}")
    print(f"Total Valid Images:       {total_valid}")
    print(f"Total Corrupt Images:     {total_corrupt}")
    print(f"Number of Duplicates:     {total_duplicates}")
    
    if imbalance_ratio == float('inf'):
        imbalance_str = "Infinite (one or more classes have 0 valid images)"
    else:
        imbalance_str = f"{imbalance_ratio:.4f}"
    print(f"Class Imbalance Ratio:    {imbalance_str}")
    
    print("-" * 65)
    print("Image Dimensions Statistics (Valid Images Only):")
    if total_valid > 0:
        print(f"  Width:  Min = {min_width}px, Max = {max_width}px, Avg = {avg_width:.2f}px")
        print(f"  Height: Min = {min_height}px, Max = {max_height}px, Avg = {avg_height:.2f}px")
    else:
        print("  No valid images to calculate dimensions.")
        
    print("-" * 65)
    print("Image Count Breakdown Per Class:")
    print(f"  {'Class Name':<22} | {'Total':<6} | {'Valid':<6} | {'Corrupt':<7} | {'Dupes':<6}")
    print(f"  {'-'*22}-+-{'-'*6}-+-{'-'*6}-+-{'-'*7}-+-{'-'*6}")
    for cls_name, stats in class_stats.items():
        print(f"  {cls_name:<22} | {stats['total']:<6} | {stats['valid']:<6} | {stats['corrupt']:<7} | {stats['duplicates']:<6}")
        
    print("=" * 65)
    print("Reports Generated successfully:")
    print(f"  - Summary:    {summary_path.name}")
    print(f"  - Details:    {details_path.name}")
    print(f"  - Corrupt:    {corrupt_path.name}")
    print(f"  - Duplicates: {duplicate_path.name}")
    print(f"Reports Location: {reports_path.resolve()}")
    print("=" * 65 + "\n")

if __name__ == "__main__":
    main()
