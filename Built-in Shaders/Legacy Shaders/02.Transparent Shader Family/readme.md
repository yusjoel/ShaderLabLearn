## 和Normal Shader Family的主要区别

1. _MainTex增加Alpha通道

2. Tags从"RenderType"="Opaque" 变成了 {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}

3. 增加了 alpha:fade

4. 部分Shader设置了target 3.0