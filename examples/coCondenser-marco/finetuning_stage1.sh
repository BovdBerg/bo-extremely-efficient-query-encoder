python -m tevatron.driver.train \
  --output_dir ./retriever_model_s1 \
  --model_name_or_path Luyu/co-condenser-marco \
  --save_steps 20000 \
  --train_dir ./marco/bert/train \
  --fp16 \
  --per_device_train_batch_size 8 \
  --learning_rate 5e-6 \
  --num_train_epochs 3 \
  --dataloader_num_workers 2
