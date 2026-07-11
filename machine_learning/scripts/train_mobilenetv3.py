#!/usr/bin/env python3
"""
MobileNetV3 Dataset Training Script for NarcoLib.

This script trains a MobileNetV3Large model using Keras/TensorFlow for drug class identification.
It implements a two-phase training strategy (freezing/fine-tuning), manages class imbalance
with class weights, and saves performance metrics, histories, and plots.
"""

import argparse
import csv
import json
import os
import sys
import datetime
from pathlib import Path
from typing import Dict, List, Tuple, Optional
import numpy as np
import tensorflow as tf
from sklearn.utils import class_weight
from sklearn.metrics import classification_report, confusion_matrix, precision_recall_fscore_support

# Import matplotlib safely for headless servers
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

# Supported image extensions
SUPPORTED_EXTENSIONS = {'.jpg', '.jpeg', '.png', '.bmp', '.webp'}

class TerminateAndRaiseOnNaN(tf.keras.callbacks.Callback):
    """Callback that terminates training and raises an error if NaN loss is encountered."""
    def on_epoch_end(self, epoch, logs=None):
        logs = logs or {}
        loss = logs.get('loss')
        val_loss = logs.get('val_loss')
        for metric_val, name in [(loss, 'loss'), (val_loss, 'val_loss')]:
            if metric_val is not None and (np.isnan(metric_val) or np.isinf(metric_val)):
                raise ValueError(f"Training aborted: NaN/Inf {name} encountered at epoch {epoch + 1}")

def verify_dataset(train_dir: Path, val_dir: Path, test_dir: Path) -> List[str]:
    """
    Perform structural checks on the dataset.
    
    Checks:
        - Missing dataset folders.
        - Mismatched class names across splits.
        - Empty class folders.
        - Unreadable dataset.
    """
    # 1. Missing dataset folders
    for folder in [train_dir, val_dir, test_dir]:
        if not folder.exists():
            raise FileNotFoundError(f"Missing dataset folder: '{folder}'")
        if not folder.is_dir():
            raise NotADirectoryError(f"Path is not a directory: '{folder}'")
            
    # 2. Automatically load class names alphabetically
    train_classes = sorted([d.name for d in train_dir.iterdir() if d.is_dir() and not d.name.startswith('.')])
    val_classes = sorted([d.name for d in val_dir.iterdir() if d.is_dir() and not d.name.startswith('.')])
    test_classes = sorted([d.name for d in test_dir.iterdir() if d.is_dir() and not d.name.startswith('.')])
    
    if not train_classes:
        raise ValueError(f"Unreadable dataset: No class subdirectories found in '{train_dir}'")
        
    # 3. Mismatched class names
    if train_classes != val_classes or train_classes != test_classes:
        raise ValueError(
            f"Mismatched class folders across splits:\n"
            f"  Train: {train_classes}\n"
            f"  Val:   {val_classes}\n"
            f"  Test:  {test_classes}"
        )
        
    # 4. Check for empty class folders
    for split_dir, split_name in [(train_dir, "Train"), (val_dir, "Validation"), (test_dir, "Test")]:
        for cls_name in train_classes:
            class_folder = split_dir / cls_name
            images = [
                f for f in class_folder.rglob('*') 
                if f.is_file() and f.suffix.lower() in SUPPORTED_EXTENSIONS
            ]
            if not images:
                raise ValueError(f"Empty class error: '{cls_name}' in the {split_name} split has 0 images.")
                
    return train_classes

def merge_histories(h1_path: Path, h2_path: Path, combined_path: Path):
    """Merge the training histories of Phase 1 and Phase 2 into a single CSV file."""
    try:
        combined_rows = []
        headers = []
        epoch_counter = 1
        
        # Read Phase 1
        if h1_path.exists():
            with open(h1_path, "r", newline="", encoding="utf-8") as f:
                reader = csv.reader(f)
                headers = next(reader)
                for row in reader:
                    row[0] = str(epoch_counter)
                    combined_rows.append(row)
                    epoch_counter += 1
                    
        # Read Phase 2
        if h2_path.exists():
            with open(h2_path, "r", newline="", encoding="utf-8") as f:
                reader = csv.reader(f)
                _ = next(reader) # skip headers
                for row in reader:
                    row[0] = str(epoch_counter)
                    combined_rows.append(row)
                    epoch_counter += 1
                    
        # Write Combined
        if combined_rows:
            with open(combined_path, "w", newline="", encoding="utf-8") as f:
                writer = csv.writer(f)
                writer.writerow(headers)
                writer.writerows(combined_rows)
    except Exception as e:
        print(f"Warning: Failed to merge training histories: {e}")

def plot_training_curves(history_csv: Path, accuracy_png: Path, loss_png: Path):
    """Plot training/validation loss and accuracy curves from combined history."""
    try:
        epochs = []
        loss = []
        acc = []
        val_loss = []
        val_acc = []
        
        with open(history_csv, "r", encoding="utf-8") as f:
            reader = csv.DictReader(f)
            for row in reader:
                # Skip blank or invalid rows
                if not row or 'epoch' not in row or not row['epoch'].strip():
                    continue
                    
                epochs.append(int(row['epoch']) + 1)  # 1-based indexing for plots
                loss.append(float(row['loss']))
                val_loss.append(float(row['val_loss']))
                
                # Support different spelling of metric name if custom keras version changes it
                acc_key = 'categorical_accuracy'
                if 'categorical_accuracy' in row:
                    acc_key = 'categorical_accuracy'
                elif 'accuracy' in row:
                    acc_key = 'accuracy'
                    
                val_acc_key = 'val_' + acc_key
                
                acc.append(float(row[acc_key]))
                val_acc.append(float(row[val_acc_key]))
                
        # Plot Accuracy
        plt.figure(figsize=(8, 5))
        plt.plot(epochs, acc, label='Training Accuracy', color='blue', lw=2)
        plt.plot(epochs, val_acc, label='Validation Accuracy', color='orange', lw=2)
        plt.title('Training & Validation Accuracy')
        plt.xlabel('Epoch')
        plt.ylabel('Accuracy')
        plt.legend(loc='lower right')
        plt.grid(True, linestyle='--', alpha=0.6)
        plt.tight_layout()
        plt.savefig(accuracy_png, dpi=150)
        plt.close()
        
        # Plot Loss
        plt.figure(figsize=(8, 5))
        plt.plot(epochs, loss, label='Training Loss', color='blue', lw=2)
        plt.plot(epochs, val_loss, label='Validation Loss', color='orange', lw=2)
        plt.title('Training & Validation Loss')
        plt.xlabel('Epoch')
        plt.ylabel('Loss')
        plt.legend(loc='upper right')
        plt.grid(True, linestyle='--', alpha=0.6)
        plt.tight_layout()
        plt.savefig(loss_png, dpi=150)
        plt.close()
        
    except Exception as e:
        print(f"Warning: Failed to generate training plots: {e}")

def main():
    parser = argparse.ArgumentParser(description="Train MobileNetV3 Classifier on NarcoLib Dataset")
    parser.add_argument(
        "--train-dir",
        type=str,
        default=r"E:\project\narcolib_app\machine_learning\data_split\train",
        help="Path to training split directory"
    )
    parser.add_argument(
        "--val-dir",
        type=str,
        default=r"E:\project\narcolib_app\machine_learning\data_split\validation",
        help="Path to validation split directory"
    )
    parser.add_argument(
        "--test-dir",
        type=str,
        default=r"E:\project\narcolib_app\machine_learning\data_split\test",
        help="Path to testing split directory"
    )
    parser.add_argument(
        "--models-dir",
        type=str,
        default=r"E:\project\narcolib_app\machine_learning\models",
        help="Directory to save Keras models"
    )
    parser.add_argument(
        "--reports-dir",
        type=str,
        default=r"E:\project\narcolib_app\machine_learning\reports",
        help="Directory to save report outputs"
    )
    
    args = parser.parse_args()
    
    train_dir = Path(args.train_dir)
    val_dir = Path(args.val_dir)
    test_dir = Path(args.test_dir)
    models_dir = Path(args.models_dir)
    reports_dir = Path(args.reports_dir)
    
    # 1. Structural Checks on Dataset
    print("Performing dataset validation checks...")
    try:
        class_names = verify_dataset(train_dir, val_dir, test_dir)
        num_classes = len(class_names)
        print(f"Dataset checks passed. Classes identified: {class_names}")
    except Exception as e:
        print(f"Dataset Verification Failed: {e}", file=sys.stderr)
        sys.exit(1)
        
    # Ensure save paths exist
    models_dir.mkdir(parents=True, exist_ok=True)
    reports_dir.mkdir(parents=True, exist_ok=True)
    
    # 2. Load Datasets using Keras
    print("\nLoading datasets...")
    image_size = (224, 224)
    batch_size = 16
    seed = 42
    
    train_ds = tf.keras.utils.image_dataset_from_directory(
        train_dir,
        image_size=image_size,
        batch_size=batch_size,
        seed=seed,
        label_mode='categorical',
        shuffle=True
    )
    
    val_ds = tf.keras.utils.image_dataset_from_directory(
        val_dir,
        image_size=image_size,
        batch_size=batch_size,
        seed=seed,
        label_mode='categorical',
        shuffle=False
    )
    
    test_ds = tf.keras.utils.image_dataset_from_directory(
        test_dir,
        image_size=image_size,
        batch_size=batch_size,
        seed=seed,
        label_mode='categorical',
        shuffle=False
    )
    
    # Check for empty / unreadable loaded datasets
    if len(train_ds) == 0:
        print("Error: Train dataset loaded 0 images.", file=sys.stderr)
        sys.exit(1)
        
    # 3. Calculate Class Weights using scikit-learn
    print("\nCalculating class weights...")
    train_labels = []
    for _, labels in train_ds:
        train_labels.append(labels.numpy())
    train_labels = np.concatenate(train_labels, axis=0)
    train_y_integers = np.argmax(train_labels, axis=1)
    
    class_counts = np.bincount(train_y_integers)
    classes_present = np.unique(train_y_integers)
    
    class_weights_val = class_weight.compute_class_weight(
        class_weight='balanced',
        classes=classes_present,
        y=train_y_integers
    )
    
    class_weights_dict = dict(zip(classes_present, class_weights_val))
    
    print("Class summary & calculated weights:")
    for idx, name in enumerate(class_names):
        count = class_counts[idx] if idx < len(class_counts) else 0
        weight = class_weights_dict.get(idx, 1.0)
        print(f"  Class {idx} - {name:<20}: count = {count:<5} weight = {weight:.6f}")
        
    # 4. Dataset Performance Configuration
    AUTOTUNE = tf.data.AUTOTUNE
    train_ds_perf = train_ds.cache().prefetch(buffer_size=AUTOTUNE)
    val_ds_perf = val_ds.cache().prefetch(buffer_size=AUTOTUNE)
    test_ds_perf = test_ds.prefetch(buffer_size=AUTOTUNE)
    
    # 5. Define Data Augmentation
    data_augmentation = tf.keras.Sequential([
        tf.keras.layers.RandomFlip("horizontal", seed=seed),
        tf.keras.layers.RandomRotation(0.08, seed=seed),
        tf.keras.layers.RandomZoom(0.10, seed=seed),
        tf.keras.layers.RandomContrast(0.10, seed=seed),
        tf.keras.layers.RandomTranslation(height_factor=0.05, width_factor=0.05, seed=seed)
    ], name="data_augmentation")
    
    # 6. Build the Keras Model Architecture
    print("\nBuilding MobileNetV3Large model architecture...")
    try:
        # Check if include_preprocessing is supported by the installed TensorFlow/Keras version
        base_model = tf.keras.applications.MobileNetV3Large(
            input_shape=(224, 224, 3),
            include_top=False,
            weights="imagenet",
            include_preprocessing=True
        )
        preprocessing_needed = False
        print("  Base model created with built-in preprocessing.")
    except TypeError:
        # Fallback if include_preprocessing is not a valid argument
        base_model = tf.keras.applications.MobileNetV3Large(
            input_shape=(224, 224, 3),
            include_top=False,
            weights="imagenet"
        )
        preprocessing_needed = True
        print("  Base model created. Manual Rescaling layer will be added to the input.")
        
    # Functional Keras API assembly
    inputs = tf.keras.Input(shape=(224, 224, 3))
    
    # Augmentation
    x = data_augmentation(inputs)
    
    # Manual preprocessing if base model does not include it
    if preprocessing_needed:
        # Scale pixels from [0, 255] to [-1, 1] as required by MobileNetV3 without include_preprocessing
        x = tf.keras.layers.Rescaling(scale=1./127.5, offset=-1.0)(x)
        
    # Set base model layer calls with training=False so BN layers stay in inference mode
    x = base_model(x, training=False)
    x = tf.keras.layers.GlobalAveragePooling2D()(x)
    x = tf.keras.layers.Dropout(0.30)(x)
    x = tf.keras.layers.Dense(256, activation='relu')(x)
    x = tf.keras.layers.Dropout(0.20)(x)
    outputs = tf.keras.layers.Dense(num_classes, activation='softmax')(x)
    
    model = tf.keras.Model(inputs, outputs)
    model.summary()
    
    # Combined history output path
    combined_history_path = reports_dir / "training_history.csv"
    if combined_history_path.exists():
        try:
            os.remove(combined_history_path)
        except Exception:
            pass
            
    # ------------------ PHASE 1 TRAINING (Frozen Base) ------------------
    print("\n" + "=" * 65)
    print("                     PHASE 1: TRAINING TOP LAYERS")
    print("=" * 65)
    
    # Freeze MobileNetV3 Base
    base_model.trainable = False
    
    model.compile(
        optimizer=tf.keras.optimizers.Adam(learning_rate=0.001),
        loss="categorical_crossentropy",
        metrics=["categorical_accuracy"]
    )
    
    model_checkpoint_p1 = models_dir / "narcolib_mobilenetv3_phase1.keras"
    
    callbacks_p1 = [
        tf.keras.callbacks.ModelCheckpoint(
            filepath=str(model_checkpoint_p1),
            monitor="val_loss",
            save_best_only=True,
            mode="min"
        ),
        tf.keras.callbacks.EarlyStopping(
            monitor="val_loss",
            patience=6,
            restore_best_weights=True,
            mode="min"
        ),
        tf.keras.callbacks.ReduceLROnPlateau(
            monitor="val_loss",
            factor=0.2,
            patience=3,
            min_lr=1e-7,
            mode="min"
        ),
        tf.keras.callbacks.CSVLogger(str(combined_history_path), append=True),
        TerminateAndRaiseOnNaN()
    ]
    
    try:
        history_p1 = model.fit(
            train_ds_perf,
            validation_data=val_ds_perf,
            epochs=25,
            class_weight=class_weights_dict,
            callbacks=callbacks_p1,
            verbose=1
        )
        epochs_run_p1 = len(history_p1.history['loss'])
    except Exception as e:
        print(f"\nPhase 1 Training aborted due to exception: {e}", file=sys.stderr)
        sys.exit(1)
        
    # ------------------ PHASE 2 FINE-TUNING (Unfreeze last 30 layers) ------------------
    print("\n" + "=" * 65)
    print("                     PHASE 2: FINE-TUNING BASE MODEL")
    print("=" * 65)
    
    # Unfreeze base model and freeze all except the last 30 layers
    base_model.trainable = True
    
    num_base_layers = len(base_model.layers)
    unfreeze_cutoff = max(0, num_base_layers - 30)
    
    for i, layer in enumerate(base_model.layers):
        if i < unfreeze_cutoff:
            layer.trainable = False
        else:
            # Keep all BatchNormalization layers frozen inside the base model
            if isinstance(layer, (tf.keras.layers.BatchNormalization, 
                                  tf.keras.layers.LayerNormalization)) or "BatchNormalization" in layer.__class__.__name__:
                layer.trainable = False
            else:
                layer.trainable = True
                
    # Recompile with learning rate 0.00001
    model.compile(
        optimizer=tf.keras.optimizers.Adam(learning_rate=0.00001),
        loss="categorical_crossentropy",
        metrics=["categorical_accuracy"]
    )
    
    model_checkpoint_p2 = models_dir / "narcolib_mobilenetv3_best.keras"
    
    callbacks_p2 = [
        tf.keras.callbacks.ModelCheckpoint(
            filepath=str(model_checkpoint_p2),
            monitor="val_loss",
            save_best_only=True,
            mode="min"
        ),
        tf.keras.callbacks.EarlyStopping(
            monitor="val_loss",
            patience=6,
            restore_best_weights=True,
            mode="min"
        ),
        tf.keras.callbacks.ReduceLROnPlateau(
            monitor="val_loss",
            factor=0.2,
            patience=3,
            min_lr=1e-7,
            mode="min"
        ),
        tf.keras.callbacks.CSVLogger(str(combined_history_path), append=True),
        TerminateAndRaiseOnNaN()
    ]
    
    try:
        model.fit(
            train_ds_perf,
            validation_data=val_ds_perf,
            initial_epoch=epochs_run_p1,
            epochs=epochs_run_p1 + 20,
            class_weight=class_weights_dict,
            callbacks=callbacks_p2,
            verbose=1
        )
    except Exception as e:
        print(f"\nPhase 2 Fine-Tuning aborted due to exception: {e}", file=sys.stderr)
        sys.exit(1)
        
    # Generate Training Accuracy and Loss Plots from combined history
    print("\nGenerating training curves...")
    plot_training_curves(
        combined_history_path,
        reports_dir / "training_accuracy.png",
        reports_dir / "training_loss.png"
    )
    
    # Load best overall model for evaluation
    print(f"\nLoading best saved model from {model_checkpoint_p2} for final evaluation...")
    if model_checkpoint_p2.exists():
        best_model = tf.keras.models.load_model(str(model_checkpoint_p2))
    else:
        best_model = model
        
    # 7. Evaluate on untouched test dataset
    print("\nEvaluating on untouched test split...")
    eval_results = best_model.evaluate(test_ds_perf, verbose=0)
    test_loss = float(eval_results[0])
    test_accuracy = float(eval_results[1])
    print(f"  Test Loss:     {test_loss:.4f}")
    print(f"  Test Accuracy: {test_accuracy:.4f}")
    
    # 8. Generate Predictions and Metrics
    print("\nGenerating prediction metrics on test dataset...")
    test_labels_all = []
    for _, labels in test_ds_perf:
        test_labels_all.append(labels.numpy())
    y_true = np.concatenate(test_labels_all, axis=0)
    y_true_indices = np.argmax(y_true, axis=1)
    
    y_pred = best_model.predict(test_ds_perf, verbose=0)
    y_pred_indices = np.argmax(y_pred, axis=1)
    
    # Precision, Recall, F1 metrics
    macro_p, macro_r, macro_f1, _ = precision_recall_fscore_support(y_true_indices, y_pred_indices, average='macro')
    weighted_p, weighted_r, weighted_f1, _ = precision_recall_fscore_support(y_true_indices, y_pred_indices, average='weighted')
    
    # Per-class scores
    p_class, r_class, f1_class, support_class = precision_recall_fscore_support(y_true_indices, y_pred_indices, labels=range(num_classes))
    
    # Save classification report as CSV
    class_report_path = reports_dir / "classification_report.csv"
    try:
        with open(class_report_path, "w", newline="", encoding="utf-8") as f:
            writer = csv.writer(f)
            writer.writerow(["class_name", "precision", "recall", "f1_score", "support"])
            for idx, name in enumerate(class_names):
                writer.writerow([
                    name,
                    round(float(p_class[idx]), 4),
                    round(float(r_class[idx]), 4),
                    round(float(f1_class[idx]), 4),
                    int(support_class[idx])
                ])
    except Exception as e:
        print(f"Error writing classification report: {e}", file=sys.stderr)
        
    # Save confusion matrix as CSV and Plot it
    cm = confusion_matrix(y_true_indices, y_pred_indices)
    cm_csv_path = reports_dir / "confusion_matrix.csv"
    try:
        with open(cm_csv_path, "w", newline="", encoding="utf-8") as f:
            writer = csv.writer(f)
            # Write class names header
            writer.writerow(["true_class \\ pred_class"] + class_names)
            for idx, name in enumerate(class_names):
                writer.writerow([name] + list(cm[idx]))
    except Exception as e:
        print(f"Error writing confusion matrix CSV: {e}", file=sys.stderr)
        
    # Confusion matrix visual plot
    cm_png_path = reports_dir / "confusion_matrix.png"
    try:
        plt.figure(figsize=(8, 6))
        plt.imshow(cm, interpolation='nearest', cmap=plt.cm.Blues)
        plt.title('Confusion Matrix')
        plt.colorbar()
        tick_marks = np.arange(num_classes)
        plt.xticks(tick_marks, class_names, rotation=45, ha='right')
        plt.yticks(tick_marks, class_names)
        
        # Text values inside confusion matrix cell blocks
        thresh = cm.max() / 2.
        for i in range(cm.shape[0]):
            for j in range(cm.shape[1]):
                plt.text(j, i, format(cm[i, j], 'd'),
                         horizontalalignment="center",
                         color="white" if cm[i, j] > thresh else "black")
                         
        plt.ylabel('True Class')
        plt.xlabel('Predicted Class')
        plt.tight_layout()
        plt.savefig(cm_png_path, dpi=150)
        plt.close()
    except Exception as e:
        print(f"Warning: Failed to plot confusion matrix PNG: {e}")
        
    # Save class names list in exactly same index order used by the model
    class_names_path = reports_dir / "class_names.txt"
    try:
        with open(class_names_path, "w", encoding="utf-8") as f:
            for name in class_names:
                f.write(f"{name}\n")
    except Exception as e:
        print(f"Error writing class_names.txt: {e}", file=sys.stderr)
        
    # Save test metrics metadata json
    metrics_json_path = reports_dir / "test_metrics.json"
    now_str = datetime.datetime.now().strftime("%Y-%m-%dT%H:%M:%S")
    
    test_metrics = {
        "metadata": {
            "tensorflow_version": tf.__version__,
            "python_version": sys.version.split()[0],
            "random_seed": seed,
            "input_dimensions": [image_size[0], image_size[1], 3],
            "batch_size": batch_size,
            "class_names": class_names,
            "training_date_time": now_str
        },
        "metrics": {
            "test_loss": round(test_loss, 6),
            "test_accuracy": round(test_accuracy, 6),
            "macro_precision": round(float(macro_p), 6),
            "macro_recall": round(float(macro_r), 6),
            "macro_f1_score": round(float(macro_f1), 6),
            "weighted_precision": round(float(weighted_p), 6),
            "weighted_recall": round(float(weighted_r), 6),
            "weighted_f1_score": round(float(weighted_f1), 6)
        }
    }
    
    try:
        with open(metrics_json_path, "w", encoding="utf-8") as f:
            json.dump(test_metrics, f, indent=4)
    except Exception as e:
        print(f"Error writing test_metrics.json: {e}", file=sys.stderr)
        
    print("\n" + "=" * 65)
    print("                      TRAINING & EVALUATION COMPLETE")
    print("=" * 65)
    print(f"Best Model File: {model_checkpoint_p2.resolve()}")
    print(f"Reports folder:  {reports_dir.resolve()}")
    print("Generated Outputs:")
    print("  - training_history.csv")
    print("  - test_metrics.json")
    print("  - classification_report.csv")
    print("  - confusion_matrix.csv")
    print("  - confusion_matrix.png")
    print("  - training_accuracy.png")
    print("  - training_loss.png")
    print("  - class_names.txt")
    print("=" * 65 + "\n")

if __name__ == "__main__":
    main()
