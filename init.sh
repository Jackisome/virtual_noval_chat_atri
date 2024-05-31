cd /opt/conda/envs
mkdir itrex
wget https://idz-ai.oss-cn-hangzhou-internal.aliyuncs.com/LLM/itrex.tar.gz
tar -zxvf itrex.tar.gz -C itrex/
tar -zxvf itrex.tar.gz -C itrex/
eval "$(conda shell.bash hook)"
conda activate itrex
rm -rf /opt/conda/envs/itrex/lib/python3.10/site-packages/torch*
pip install torch==2.2.2 torchvision==0.17.2 torchaudio==2.2.2 --index-url https://download.pytorch.org/whl/cu121
pip install translate
python -m ipykernel install --name itrex

mkdir /mnt/workspace/model
cd /mnt/workspace/model
git clone https://www.modelscope.cn/shakechen/Llama-2-7b-hf.git
git clone https://www.modelscope.cn/maidalun/bce-embedding-base_v1.git
git clone https://www.modelscope.cn/adafny123/empathy_finetune_llama_2_hf.git