# ShaderLab Pass
## Unity Manuel
* <https://docs.unity3d.com/Manual/SL-Pass.html>
## 基本语法
```
Pass { 
    [Name and Tags] 
    [RenderSetup] 
}
```
## Name
* <https://docs.unity3d.com/Manual/SL-Name.html>
* 语法
```
Name "PassName"
```
* 名字会自动转为大写, 可以配合[UsePass](https://docs.unity3d.com/Manual/SL-UsePass.html)使用
## Tags
* 参考[Pass Tags](Pass%20Tags.md)
## RenderSetup
* Cull
```
Cull Back | Front | Off
```
* ZTest
```
ZTest (Less | Greater | LEqual | GEqual | Equal | NotEqual | Always)
```