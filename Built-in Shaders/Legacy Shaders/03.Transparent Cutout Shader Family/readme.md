## 和Transparent Shader Family的主要区别

1. Properties中增加了_Cutoff

2. Tags从{"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}变成了{"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}.

3. 从alpha:fade变成了alphatest:_Cutoff, alphatest只需要使用这个语法就可以了,不需要在surf中使用到_Cutoff, 所以也不需要再次声明他.

