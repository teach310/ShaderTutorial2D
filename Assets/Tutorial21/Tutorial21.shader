Shader "ShaderTutorial/Tutorial21"
{
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		// 追加
		CGINCLUDE

		#define PI 3.14159


		float mod(float  a, float  b) { return a-b*floor(a/b); } 
		ENDCG


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
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				o.uv.y = 1-o.uv.y;
				return o;
			}

			//Plasma
			fixed4 frag (v2f i) : SV_Target
			{
				float2 r = 2.0 * (i.uv - 0.5);
				float aspectRatio = _ScreenParams.x / _ScreenParams.y;
				r.x *= aspectRatio;
				float t = _Time.y;
				r = r*8.0;

				float v1 = sin(r.x + t);
				float v2 = sin(r.y + t);
				float v3 = sin(r.x + r.y + t);
				float v4 = sin(sqrt(r.x*r.x + r.y*r.y) + 1.7*t);
				float v = v1 + v2 + v3 + v4;
				fixed3 ret;

				if(i.uv.x < 1.0 / 10.0) // part1
				{
					//vertical waves
					ret = float3(v1, v1, v1);
				}
				else if(i.uv.x < 2.0/10.0) // part2
				{
					// horizontal waves;
					ret = float3(v2, v2, v2);
				}
				else if(i.uv.x < 3.0/10.0) // part3
				{
					// diagonal waves
					ret = float3(v3, v3, v3);
				}
				else if(i.uv.x < 4.0/10.0) // part4
				{
					// circular waves
					ret = float3(v4, v4, v4);
				}
				else if(i.uv.x < 5.0/10.0) // part5
				{
					// the sum of all waves
					ret = float3(v, v, v);
				}
				else if(i.uv.x < 6.0/10.0) // part6
				{
					// Add periodicity to the gradients
					ret = float3(sin(2.0 * v), sin(2.0 * v), sin(2.0 * v));
				}
				else if(i.uv.x < 10.0/10.0) // part7
				{
					// mix colors
					v *= 1.0;
					ret = float3(sin(v), sin(v+0.5*PI), sin(v+1.0*PI));
				}

				ret = 0.5 + 0.5 * ret;

				fixed3 pixel = ret;
				return fixed4(pixel, 1.0);
			}


			ENDCG
		}
	}
}
