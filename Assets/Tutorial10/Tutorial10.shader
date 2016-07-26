Shader "ShaderTutorial/Tutorial10"
{
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		// 追加
		CGINCLUDE
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

			// Draw Disks
			fixed4 frag (v2f i) : SV_Target
			{
				float2 r = 2.0 * (i.uv - 0.5);
				float aspectRatio = _ScreenParams.x / _ScreenParams.y;
				r.x *= aspectRatio;

				fixed3 backgroundColor = fixed3(1.0, 1.0, 1.0);
				fixed3 col1 = fixed3(0.216, 0.471, 0.698); // blue
				fixed3 col2 = fixed3(1.00, 0.329, 0.298); // red
				fixed3 col3 = fixed3(0.867, 0.910, 0.247); // yellow

				fixed3 pixel = backgroundColor;
				
				//Disk1 blue
				float radius = 0.8;
				if(r.x*r.x + r.y*r.y < radius*radius){
					pixel = col1;
				}
				
				//Disk2 red
				if(length(r) < 0.3){
					pixel = col3;
				}
				
				//Disk3 yellow
				float2 center = fixed2(0.9, -0.4);
				float2 d = r - center;
				if( length(d) < 0.6){
					pixel = col2;
				}

				return fixed4(pixel, 1.0);
			}


			ENDCG
		}
	}
}
