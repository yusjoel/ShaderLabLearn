Shader "CookbookShaders/Chapter011/OldFilm"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
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
            sampler2D _BlendTex;
            fixed _Opacity;

            fixed OverlayOne(fixed base, fixed blend) 
            {
                if(base < 0.5)
                    return 2 * base *blend;

                return 1 - 2 * (1 - base) * (1 - blend);
            }

            fixed4 Overlay(fixed4 base, fixed4 blend)
            {
                fixed4 blended = base;
                blended.r = OverlayOne(base.r, blend.r);
                blended.g = OverlayOne(base.g, blend.g);
                blended.b = OverlayOne(base.b, blend.b);

                return blended;
            }

            fixed4 frag(v2f_img i) : COLOR
            {
                fixed4 renderTex = tex2D(_MainTex, i.uv);
                fixed4 blendTex = tex2D(_BlendTex, i.uv);

                // Multiply
                //fixed4 blendedColor = renderTex * blendTex;
                // Add
                //fixed4 blendedColor = renderTex + blendTex;
                // Screen
                //fixed4 blendedColor = 1 - (1 - renderTex) * (1 - blendTex);
                // Overlay
                fixed4 blendedColor = Overlay(renderTex, blendTex);
                renderTex = lerp(renderTex, blendedColor, _Opacity);

                return renderTex;
            }

            ENDCG

        }
    }

    FallBack Off
}
