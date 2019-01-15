# Chapter 1: Diffuse Shading
## 笔记1

1.5 自定义的漫反射光照模型中有一个小问题:
```ShaderLab
inline float4 LightingBasicDiffuse(SurfaceOutput s, fixed3 lightDir, fixed atten)
{
        float difLight = max(0, dot(s.Normal, lightDir));
        float4 col;
        col.rgb = s.Albedo * _LightColor0.rgb * (difLight * atten * 2);
        col.a = s.Alpha;
        return col;
}
```

这里为什么atten要乘2, 这本书写的时候使用的Unity版本是4.x, 下载4.x的内置着色器, 可以看到Lighting.cginc内的LightingLambert的代码和这个一模一样.

Candycat的读书笔记中提到[链接](https://blog.csdn.net/candycat1992/article/details/17440101):
> 细心的童鞋可以发现，这里后面多乘了一个倍数2。按我的猜测，这里仅仅是根据需要自行修改的。

不过在评论中polar1225(#13楼)提到:
> *2的原因可见参见http://forum.unity3d.com/threads/why-atten-2.94711/，Aras Pranckevičius的解释，兼容性

Aras Pranckevičius的回答[链接](https://forum.unity.com/threads/why-atten-2.94711/):
> Wow, someone brought a thread up from the dead!
> Short answer to "why multiply by two?" - because in the EarlyDays, it was a cheap way to "fake" somewhat overbright light in fixed function shaders. And then it stuck, and it kind of dragged along.
> We'd like to kill this concept. But that would mean breaking possibly a lot of existing shaders that all of you wrote (suddenly everything would become twice as bright). So yeah, a tough one... worth killing an old stupid concept or not? 
