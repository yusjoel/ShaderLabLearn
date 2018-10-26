## 和Normal Shader Family的主要区别

1. _MainTex增加Alpha通道

2. Tags从"RenderType"="Opaque" 变成了 {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}

3. 增加了alpha:fade, 可以看到在SubShader下不用定义ZWrite Off

4. 部分Shader设置了target 3.0