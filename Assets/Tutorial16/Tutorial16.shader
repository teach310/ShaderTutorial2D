Shader "ShaderTutorial/Tutorial16"
{
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		// 追加
		CGINCLUDE
		// なめらかなDISK
		float disk(float2 r, float2 center, float radius){
			float distanceFromCenter = length(r - center);
			float outsideOfDisk = smoothstep(radius - 0.005, radius + 0.005, distanceFromCenter);
			float insideOfDisk = 1.0 - outsideOfDisk;
			return insideOfDisk;

		}
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

			// ANTI-ALIASING WITH SMOOTHSTEP
			fixed4 frag (v2f i) : SV_Target
			{
				float2 r = 2.0 * (i.uv - 0.5);
				float aspectRatio = _ScreenParams.x / _ScreenParams.y;
				r.x *= aspectRatio;

				fixed3 black = float3(0.0, 0.0, 0.0); // black
				fixed3 white = float3(1.0, 1.0, 1.0);
				fixed3 gray = float3(0.3, 0.3, 0.3);
				fixed3 col1 = float3(0.216, 0.471, 0.698); // blue
				fixed3 col2 = float3(1.00, 0.329, 0.298); // red
				fixed3 col3 = float3(0.867, 0.910, 0.247); // yellow

				fixed3 ret;
				fixed3 pixel;
				float d;


				if(i.uv.x < 1.0/3.0){ // part1
					ret = gray;
					d = disk(r, float2(-1.1, 0.3), 0.4);
					ret = lerp(ret, col1, d);
					d = disk(r, float2(-1.3, 0.0), 0.4);
					ret = lerp(ret, col2, d);
					d = disk(r, float2(-1.05, -0.3), 0.4);
					ret = lerp(ret, col3, d);
				}
				else if(i.uv.x < 2.0/3.0){ // part2
					// Color addition
					ret = black;
					ret += disk(r, float2(0.1, 0.3), 0.4) * col1;
					ret += disk(r, float2(-0.1, 0.0), 0.4) * col2;
					ret += disk(r, float2(0.15, -0.3), 0.4) * col3;
 				}
				else if(i.uv.x < 3.0/ 3.0){ // part3
					// Color substraction
					ret = white;
					ret -= disk(r, float2(1.1, 0.3), 0.4) * col1;
					ret -= disk(r, float2(1.05, 0.0), 0.4) * col2;
					ret -= disk(r, float2(1.35, -0.25), 0.4) * col3;

				}



				pixel = ret;
				return fixed4(pixel, 1.0);
			}


			ENDCG
		}
	}
}
