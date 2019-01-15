#ifndef LAMBERT_INCLUDE
#define LAMBERT_INCLUDE

inline fixed4 LightingCustomLambert(SurfaceOutput s, fixed3 lightDir, fixed atten)
{
    fixed diff = dot(s.Normal, lightDir);

    #ifdef HALF_LAMBERT
    diff = (diff + 1) * 0.5;
    #else
    diff = max(0, diff);
    #endif

    fixed4 c;
    c.rgb = s.Albedo * _LightColor0.rgb * diff;
    c.a = s.Alpha;
    return c;
}

#endif