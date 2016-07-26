Shader "ShaderTutorial/Tutorial13"
{
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		// 追加
		CGINCLUDE
		#define PI 3.14159
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

			// BUILT-IN FUNCTION: CLAMP
			fixed4 frag (v2f i) : SV_Target
			{
				float2 r = 2.0 * (i.uv - 0.5);
				float aspectRatio = _ScreenParams.x / _ScreenParams.y;
				r.x *= aspectRatio;

				fixed3 backgroundColor = fixed3(0.0, 0.0, 0.0); // black
				fixed3 col1 = fixed3(0.216, 0.471, 0.698); // blue
				fixed3 col2 = fixed3(1.00, 0.329, 0.298); // red
				fixed3 col3 = fixed3(0.867, 0.910, 0.247); // yellow

				fixed3 pixel = backgroundColor;
				
				float edge, variable, ret;

				// divide the screen into four parts horizontally
				// for different examples
				if(i.uv.x < 0.25){ // part1
					ret = i.uv.y;
				}
				else if(i.uv.x < 0.5){ // part2
					float minVal = 0.3;
					float maxVal = 0.6;
					variable = i.uv.y;
					if (variable < minVal){
						ret = minVal;
					}
					if( variable > minVal && variable < maxVal){
						ret = variable;
					}
					if( variable > maxVal ){
						ret = maxVal;
					}
				}
				else if(i.uv.x < 0.75){ // part3
					float minVal = 0.6;
					float maxVal = 0.8;
					variable = i.uv.y;
					ret = clamp(variable, minVal, maxVal);
				}
				else { // part4
					float y = cos(5.0 * 2.0 * PI *i.uv.y);
					y = (y+1.0)*0.5; // map [-1,1] to [0,1]
					ret = clamp(y, 0.2, 0.8);
				}

				pixel = fixed3 (ret, ret, ret);
				return fixed4(pixel, 1.0);
			}


			ENDCG
		}
	}
}
