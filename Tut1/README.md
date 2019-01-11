# 学习1 《3D Graphics with XNA Game Studio 4.0》
## 概述
* [PACKT](https://www.packtpub.com/game-development/3d-graphics-xna-game-studio-40)
* [Amazon](https://www.amazon.com/Graphics-XNA-Game-Studio-4-0/dp/1849690049)
这本书主要介绍XNA 4.0环境下如何实现一些3D效果, 主要通过使用着色器(HLSL)来实现.

这里尝试在Unity3D环境下, 使用ShaderLab进行实现.

本书的一些其他内容就不再关心了.

XNA 4.0是在DirectX 9之上的一个封装, 功能上比DirectX 9要少.

使用起来比直接DirectX或者OpenGL开发更简便一些, 并且使用的语音也是C#.

和Unity3D相比, 还是暴露了不少基础的部分, 比如镜头如何创建, 物件如何描绘, 灯光如何参与描绘等等.

在ShaderLab的编写过程中, 尽量保持了原代码的命名和代码风格.

Unity3D版本: Unity 5.6.5p2

## Chapter 2: Introduction to HLSL
### 01.Simple Effect
最简单的版本, 将模型使用单色描绘出来.

[SimpleEffect](Assets/Shaders/Chapter 2/01.SimpleEffect/README.md)
 