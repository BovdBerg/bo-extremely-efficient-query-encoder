SCRIPT_DIR=$PWD
TOKENIZER=bert-base-uncased
TOKENIZER_ID=bert
HN_DIR=$TOKENIZER_ID/train-hn

cd marco
mkdir -p $HN_DIR
python $SCRIPT_DIR/build_train_hn.py \
  --tokenizer_name $TOKENIZER \
  --hn_file ../train.rank.txt \
  --qrels qrels.train.tsv \
  --queries train.query.txt \
  --collection corpus.tsv \
  --save_to $HN_DIR
cd ..
cd $HN_DIR
ln -s ../train/* .
ln -s $TOKENIZER_ID/train/* $HN_DIR
cd ../../..
