extremely-efficient-online-query-encoding-for-dense-retrieval is an extension of the popular 
[Tevatron package](https://github.com/texttron/tevatron/) 
([commit](https://github.com/texttron/tevatron/commit/b8f33900895930f9886012580e85464a5c1f7e9a)),
adding the ability to use a small query encoder (with a large passage encoder) to have very low encoding time, while 
incurring minor impact in quality. 

## Instructions

### Set up Conda environment
0. Clone the repository.
1. Install PyTorch based on your CUDA version from [PyTorch](https://pytorch.org/get-started/locally/).
2. Install dependencies and Tevatron.
```bash
conda create -y -n tevatron python
conda activate tevatron

pip install --user --upgrade pip setuptools
pip install git+https://github.com/texttron/tevatron.git@tevatron-v1
# git clone https://github.com/texttron/tevatron.git
# cd tevatron
# git checkout tevatron-v1
# pip install -e .
# cd ../

conda install -c nvidia cuda-compiler cuda pytorch::faiss-cpu
pip install torch==1.10.1 faiss-cpu==1.7.2 transformers==4.15.0 datasets==1.17.0 peft deepspeed accelerate cycler lightning[extra] numpy
```
On Delftblue I got this vague error: https://stackoverflow.com/questions/77364550/attributeerror-module-pkgutil-has-no-attribute-impimporter-did-you-mean
- I solved it by 
```
module purge
module load 2023r1 miniconda3 DefaultModules
pip install -e .
module unload py-numpy  py-scipy py-setuptools py-matplotlib
``` 
and maybe more outdated packages that are automatically loaded.


### Preparation 
Prepare data, tokenizer, negative samples, etc.
Use the guidelines from examples/coCondenser-marco/README.md loosely...
I tweaked the file get_data.sh (see below) to fit this reproduction more appropriately.
1. `cd /examples/coCondenser-marco`
2. Execute all instructions in the other README:
    - Get Data
    - Inference with Fine-tuned Checkpoint
    - Fine-tuning Stage 1:
        - Run:
        ```
        PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python
        bash finetuning_stage1.sh
        ```
    - Mining Hard Negatives
    <!-- - Fine-tuning Stage 2 -->
    <!-- - Encode and Search -->


### From Amazon extension
0. `cd src/`
1. Create (teacher) embeddings for all queries in the train set, using `bash encoder_teacher.sh`
2. Run pretraining using `bash pretrain.sh`
<!-- TODO: 3. Is 'Mining hard negatives' missing here?... -->
3. Run training using `bash marco_train_pretrained_model.sh <PRETRAINED_MODEL>`
    - e.g. `bash marco_train_pretrained_model.sh ../outputs/pretrained_models/240812-114052-352516`
4. Evaluate using `bash full_eval.sh <MODEL_PATH>`
    - e.g. `bash full_eval.sh "../outputs/models/reproduce/240812-114052-352516_e3_"` with the 2 variables from marco_train_pretrained_model.sh.\
      - nothing after last _ because {TP} var does not exist in marco_train_pretrained_model.sh.


## Citations

```
@article{cohen2024indi,
  title={Extremely efficient online query encoding for dense retrieval},
  author={Cohen, Nachshon and Fairstein, Yaron and Kushilevitz, Guy},
  booktitle={Findings of the Association for Computational Linguistics: NAACL 2024},
  year={2024}
}
```
