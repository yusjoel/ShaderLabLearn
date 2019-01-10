Shader "CookbookShaders/Chapter010/SceneDepth"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}    
        _DepthPower ("Depth Power", Range(0, 5)) = 1
    }

    SubShader
    {
        pass
        {
            ZTest Always
            Cull Off
            ZWrite Off

            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            fixed _DepthPower;
            sampler2D _CameraDepthTexture;

            fixed4 frag(v2f_img i) : COLOR
            {
                float d = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv);
                d = pow(Linear01Depth(d), _DepthPower);

                return d;
            }

            ENDCG

        }
    }

    FallBack Off
}
