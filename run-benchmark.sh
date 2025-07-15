#!/bin/bash

MODEL_NAME="huggingface-model-name"
TASK_NAME="task-name"
BASE_OUTPUT_DIR="output-dir"
SEEDS=(3047 1024 456 789 999)

# Tạo thư mục results nếu chưa có
mkdir -p $BASE_OUTPUT_DIR

echo "Bắt đầu chạy benchmark:"

for i in "${!SEEDS[@]}"; do
    run_num=$((i + 1))
    seed=${SEEDS[$i]}
    output_dir="$BASE_OUTPUT_DIR/run_$run_num"
    
    echo "Đang chạy lần $run_num với seed $seed..."
    
    lm_eval --model hf \
      --model_args pretrained=$MODEL_NAME \
      --tasks $TASK_NAME \
      --seed $seed \
      --gen_kwargs temperature=0.2,do_sample=true \
      --cache_requests refresh \
      --output_path $output_dir \
      --log_samples \
      --write_out \
      --batch_size auto
    
    echo "Hoàn thành lần $run_num"
    echo "Kết quả được lưu tại: $output_dir"
    echo "----------------------------------"
done