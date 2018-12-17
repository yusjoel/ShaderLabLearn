
// Shader动态切换效果
// 效果是从某个中心点开始, 目标材质呈球形向外扩展 (也可以改成立方体或者其他)
// _LerpSpeed是扩展速度
// _LerpDelay是延迟, 在延迟内, 颜色是渐变的
// _LerpTime需要外部传入, 便是动态切换效果开始后经过的时间
// 中心点      Time-Delay       Time            
//   +-----------+--------------+---------------
//      完全是To     To/From差值     依旧是From

// 使用:
// 对于要进行动态切换的属性, 增加一套加了LerpTo后缀的变量
// 在使用到这些属性的地方, 将其替换成LERP_PROP(prop)

// struct Input 
// {
//	float3 worldPos; // Add this
// };

float _LerpSpeed;
float _LerpDelay;
float _LerpTime;
float4 _WorldOrigin;

float CalculateWeight(float3 worldPos)
{
	//float d = abs(worldPos.x - _WorldOrigin.x);
	float3 modelPos = mul(unity_WorldToObject, float4(worldPos, 1)).xyz;
	float3 modelOrigin = mul(unity_WorldToObject, _WorldOrigin).xyz;
	float d = distance(modelPos, modelOrigin);
	float weight = saturate((_LerpTime - d / _LerpSpeed) / _LerpDelay);
	return weight;
}

#define INIT_LERP float weight = CalculateWeight(IN.worldPos)

#define LERP_PROP(v) (lerp(v, v##LerpTo, weight))