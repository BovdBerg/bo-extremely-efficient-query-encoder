python -m tevatron.driver.train \
  --output_dir ./retriever_model_s2 \
  --model_name_or_path CONDENSER_MODEL_NAME \
  --save_steps 20000 \
  --train_dir ./marco/bert/train-hn \
  --fp16 \
  --per_device_train_batch_size 8 \
  --learning_rate 5e-6 \
  --num_train_epochs 2 \
  --dataloader_num_workers 2
