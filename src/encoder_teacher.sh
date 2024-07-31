python -m tevatron.driver.encode \
    --output_dir /tmp/encode \
    --model_name_or_path Luyu/co-condenser-marco \
    --fp16 \
    --per_device_eval_batch_size 128 \
    --encode_in_path ../resources/pretrain_data/train_queries_tokens.jsonl \
    --encoded_save_path ../resources/pretrain_data/train_queries.pt
