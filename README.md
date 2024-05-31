<center><big><b>视觉小说对话机器人设计</b></big></center>
<center>小组：旦复旦</center>

# 项目成员

邓勇军 复旦大学

# 应用功能

《亚托莉-我挚爱的时光》是2020年发售的一款视觉小说游戏，描述了在海平面上升淹没大片土地、威胁人类生存的未来世界里，主人公斑鸠夏生因事故失去右腿，与神白水菜萌重逢。搬到海边小镇后，他发现机器人少女亚托莉，她声称与夏生仅有45天相处。在共同生活中，夏生对亚托莉产生情感，却发现她的情感仅是计算出来的假象，令他痛苦不堪。亚托莉的过去揭开：拥有“心”的她，曾为诗菜殉情、为夏生受伤。冲突升级，涉及创作者安田的复仇计划。游戏结局各异，最终夏生和亚托莉在特殊岛屿相聚，诉说情感，诺亚都市的未来充满期待。

本项目借助语言大模型和Intel所提供的微调、推理等功能，实现了基于角色扮演的聊天机器人。优化之后的模型应用，相比与直接调用大模型，在对话过程的共情能力以及对于人物设定的理解上，更贴近于故事本身，容易引起玩家的共鸣。

本项目所使用的技术具有通用性，方便扩展到更多的故事情节中，供具有不同喜好的玩家自行选择所扮演的角色，以及对话对象。

# 技术特点

+ 共情能力提升：基于Lora，使用情感对话系统所关联的公开数据集，提取对话中的问答内容，整理成Alpaca格式数据集，对Llama-2-7b-hf模型进行微调
+ 故事剧情感知：通过RAG，使用游戏汉化组所公开的游戏剧情文本作为检索文档，通过bce-embedding-base_v1向量化之后，在推理过程中，提升chatbot所返回结果与故事的关联性，使对话更符合游戏世界观与人物设定

# 功能设计

![image-20240502171843246](C:\Users\happy\AppData\Roaming\Typora\typora-user-images\image-20240502171843246.png)

# 设备

CPU: Intel(R) Xeon(R) Platinum 8163 CPU @ 2.50GHz * 12

GPU: Nvidia A100 32GB

内存 90G

## 模型训练

1. 模型微调

下载共情对话数据集，编写python程序，使用translate包进行语料的英译中，并转换成Alpaca格式。基于intel_extension_for_transformers所提供的微调方式，使用该数据集，采用Lora技术，对Llama-2-7b-hf中，'k_proj', 'q_proj', 'o_proj', 'v_proj'模块进行微调，对1600多万，约0.24%的参数进行训练，得到模型empathy_finetune_llama_2_hf。训练过程对参数进行fp16量化。此处微调的目的，是提高模型在对话过程中，对玩家输入所体现情感的共情能力。

## 模型推理

1. 检索增强

简短的prompt难以全面描述游戏所展示的世界观和角色性格，基于RAG技术，利用intel_extension_for_transformers所提供的retrieval插件，使用bce-embedding-base_v1将游戏的故事文本进行向量化，加入到玩家提问的推理过程中，使chatbot的回复更符合游戏设定。

2. prompt

项目的对话设计为玩家扮演故事主角夏生，与另一位主角亚托莉进行对话。因此，在对话开始之前，通过prompt，提示chatbot模仿亚托莉性格，结合故事背景，以角色扮演的形式提供回答。intel_extension_for_transformers提供了cache插件，保持最初对于chatbot的prompt设定进行持续对话。

3. 量化加速

在训练过程中，通过intel_extension_for_transformers所提供的optimization_config，尝试进行TRN 4bits量化，提高玩家对话过程中的响应速度。但量化未生效。采取默认配置时，平均延迟大约 1.82 秒

对话截图如下，chatbot能获取游戏情节相关内容，并进行一定程度上的同理对话：

![image-20240518215712900](C:\Users\happy\AppData\Roaming\Typora\typora-user-images\image-20240518215712900.png)

# 项目和引用链接

## 项目文档及数据

1. 项目源码（数据转换、训练及推理源码）：https://github.com/Jackisome/virtual_noval_chat_atri
2. 微调之后的模型empathy_finetune_llama_2_hf：https://modelscope.cn/models/adafny123/empathy_finetune_llama_2_hf/summary
3. 微调使用的共情语料，及故事情节文本：https://modelscope.cn/datasets/adafny123/visual_noval_atri/summary

## 引用模型及数据

1. 共情对话数据集：https://github.com/thu-coai/Emotional-Support-Conversation
2. Llama-2-7b-hf：https://modelscope.cn/models/shakechen/Llama-2-7b-hf/summary
3. bce-embedding-base_v1：https://modelscope.cn/models/maidalun/bce-embedding-base_v1/summary