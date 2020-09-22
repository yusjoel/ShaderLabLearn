# 概述
如果使用了法线贴图, 那么计算得到的法线是在切线空间下.
如果此时还需要使用世界空间下的法线, 或者更进一步需要计算世界坐标下的反射光方向, 就需要使用切线空间到世界空间的转换矩阵.
INTERNAL_DATA宏就是这个转换矩阵. 
该宏并没有定义在哪个文件中, 而是在生成代码时自动添加, 并同时添加以下两个宏:
 WorldReflectionVector (IN, o.Normal)
 WorldNormalVector (IN, o.Normal)
# INTERNAL_DATA
```ShaderLab
#define INTERNAL_DATA \
	half3 internalSurfaceTtoW0; \
	half3 internalSurfaceTtoW1; \
	half3 internalSurfaceTtoW2;
```
# WorldReflectionVector
```ShaderLab
// worldRefl中传入的是视角方向
surfIN.worldRefl = -worldViewDir;

#define WorldReflectionVector(data,normal) \
	reflect (data.worldRefl, half3( \
		dot(data.internalSurfaceTtoW0,normal), \
		dot(data.internalSurfaceTtoW1,normal), \
		dot(data.internalSurfaceTtoW2,normal)))
```
# WorldNormalVector
```ShaderLab
#define WorldNormalVector(data,normal) \
	fixed3( \
		dot(data.internalSurfaceTtoW0,normal), \
		dot(data.internalSurfaceTtoW1,normal), \
		dot(data.internalSurfaceTtoW2,normal))
```
# 参考
* <https://docs.unity3d.com/Manual/SL-SurfaceShaders.html>
* <https://docs.unity3d.com/cn/current/Manual/SL-SurfaceShaders.html>


