// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/ProCamera2D/TransitionsFX/Blinds" 
{
    Properties 
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Step ("Step", Range(0, 1)) = 0
        _BackgroundColor ("Background Color", Color) = (0, 0, 0, 1)
        _Direction ("Direction", Int) = 0
        _Blinds ("Blinds", Int) = 2
    }
    SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

            sampler2D _MainTex;
            float _Step;
            float4 _BackgroundColor;
            int _Direction;
            int _Blinds;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 colour = _BackgroundColor;

                if (_Direction == 0 && frac(i.uv.x * _Blinds) < 1 - _Step)
                    colour = tex2D(_MainTex, i.uv);
                else if (_Direction == 1 && frac(i.uv.x * _Blinds) > _Step)
                    colour = tex2D(_MainTex, i.uv);
                else if (_Direction == 2 && frac(i.uv.y * _Blinds) > _Step)
                    colour = tex2D(_MainTex, i.uv);
                else if (_Direction == 3 && frac(i.uv.y * _Blinds) < 1 - _Step)
                    colour = tex2D(_MainTex, i.uv);

                return colour;
            }

            ENDCG
        }
    }
}