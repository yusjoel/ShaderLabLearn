# 学习1 《3D Graphics with XNA Game Studio 4.0》
## Chapter 2: Introduction to HLSL
### 01.Simple Effect
#### [最简单的版本](SimpleEffect.shader)
这里仅仅进行一次MVP的变换， 输出一个固定的颜色。
#### [分拆的版本](Unity/SimpleEffect.shader)
```ShaderLab
	// 标准做法
	//output.Position = UnityObjectToClipPos(input.Position);

	// 将MVP拆开来
	//float4 position = mul(unity_ObjectToWorld, input.Position);
	//position = mul(UNITY_MATRIX_V, position);
	//position = mul(UNITY_MATRIX_P, position);

	// unity_ObjectToWorld = Target.transform.localToWorldMatrix
	float4 position = mul(_ModelMatrix, input.Position);
	// UNITY_MATRIX_V = Camera.worldToCameraMatrix
	position = mul(_ViewMatrix, position);
	// UNITY_MATRIX_P = GL.GetGPUProjectionMatrix(Camera.projectionMatrix, true);
	position = mul(_ProjectionMatrix, position);
```