Shader "ShaderTutorial/Tutorial12"
{
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		// 追加
		CGINCLUDE
		fixed3 disk(fixed2 r, fixed2 center, fixed radius, fixed3 color, fixed3 pixel){
			fixed3 col = pixel;
			if(length(r - center) < radius){
				col = color;
			}
			return col;
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

			// BUILT-IN FUNCTION: STEP
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

				// divide the screen into five parts horizontally
				// for different examples
				if(r.x < -0.6 * aspectRatio){ // part1
					variable = r.y;
					edge = 0.2;
					if( variable > edge ){
						ret = 1.0;
					}else{
						ret = 0.0;
					}
				}
				else if(r.x < -0.2 * aspectRatio){ //part2
					variable = r.y;
					edge = -0.2;
					// part1と同じこと
					ret = step(edge, variable); 
				}
				else if(r.x < 0.2 * aspectRatio){
					// 1.0 - step(a,b) で反転
					ret = 1.0 - step(0.5, r.y); 
				}
				else if(r.x < 0.6 * aspectRatio){
					// r.yが-0.4以上でretは0.3 + 0.5 = 0.8
					ret = 0.3 + 0.5 * step(-0.4, r.y);  
				}
				else{
					// stepを二つ使うことでgapを生み出すことができる
					ret = step(-0.3, r.y) * (1.0 - step(0.2, r.y)); 
				}

				pixel = fixed3 (ret, ret, ret);
				return fixed4(pixel, 1.0);
			}


			ENDCG
		}
	}
}
