python -m run_pretraining.pretrain \
    --teacher "condenser" \
    --dataset "MARCO" \
    --epochs 10 \
    --model "gru" \
    --num_layers 1 \
    --ff 0 \

    # parser.add_argument('--teacher', type=str, default="condenser", choices=["condenser", "coco"],
    #                     help='Teacher model.')
    # parser.add_argument('--dataset', type=str, default="MARCO", choices=["MARCO"], help='dataset to use.')
    # parser.add_argument('--model', type=str, default="gru",
    #                     choices=["distilbert", "gru", "lstm", "rand-bert", "condenser", "coco"],
    #                     help='student model type.')
    # parser.add_argument('--epochs', type=int, default=3, help='number of epochs.')
    #   "We pretrain for 10 epochs, as discussed in Section 4.4.1."
    # parser.add_argument('--num_layers', type=int, default=2, help='number of layers.')
    # parser.add_argument('--ff', type=int, default=0, help='number of ff layers.')
    # parser.add_argument('--dont_tie_embeddings', action='store_true', help='tie embeddings between models.')
