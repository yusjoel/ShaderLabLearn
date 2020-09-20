# Pass Tags
## Unity Manuel
* <https://docs.unity3d.com/Manual/SL-PassTags.html>
## 语法
```
Tags { "TagName1" = "Value1" "TagName2" = "Value2" }
```
## LightMode tag
* Always: Always rendered; no lighting is applied.
* ForwardBase: Used in Forward rendering, ambient, main directional light, vertex/SH lights and lightmaps are applied.
* ForwardAdd: Used in Forward rendering; additive per-pixel lights are applied, one pass per light.
* Deferred: Used in Deferred Shading; renders g-buffer.
* ShadowCaster: Renders object depth into the shadowmap or a depth texture.
* MotionVectors: Used to calculate per-object motion vectors.
* PrepassBase: Used in legacy Deferred Lighting, renders normals and specular exponent.
* PrepassFinal: Used in legacy Deferred Lighting, renders final color by combining textures, lighting and emission.
* Vertex: Used in legacy Vertex Lit rendering when object is not lightmapped; all vertex lights are applied.
* VertexLMRGBM: Used in legacy Vertex Lit rendering when object is lightmapped; on platforms where lightmap is RGBM encoded (PC & console).
* VertexLM: Used in legacy Vertex Lit rendering when object is lightmapped; on platforms where lightmap is double-LDR encoded (mobile platforms).
## PassFlags tag
* OnlyDirectional
## RequireOptions tag
* SoftVegetation: Render this pass only if Soft Vegetation is on in the Quality window.