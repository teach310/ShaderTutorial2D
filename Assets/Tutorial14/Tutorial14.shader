Shader "ShaderTutorial/Tutorial14"
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

			// BUILT-IN FUNCTION: SMOOTHSTEP
			fixed4 frag (v2f i) : SV_Target
			{
				fixed3 backgroundColor = fixed3(0.0, 0.0, 0.0); // black
				fixed3 col1 = fixed3(0.216, 0.471, 0.698); // blue
				fixed3 col2 = fixed3(1.00, 0.329, 0.298); // red
				fixed3 col3 = fixed3(0.867, 0.910, 0.247); // yellow

				fixed3 pixel = backgroundColor;
				
				float edge, variable, ret;

				// divide the screen into five parts horizontally
				// for different examples
				if(i.uv.x < 1.0/5.0){ // part1
					edge = 0.5;
					ret = step(edge, i.uv.y);
				}
				else if(i.uv.x < 2.0/5.0){ // part2
					float edge0 = 0.45;
					float edge1 = 0.55;
					float t = (i.uv.y - edge0) / (edge1 - edge0);
					//when i.uv.y == edge0 => t = 0.0
					//when i.uv.y == edge1 => t = 1.0
					//0から1に線形に遷移する
					float t1 = clamp(t, 0.0, 1.0);
					//edge0 未満の時は マイナスの値をとり，
					//edge1 より大きい時は1.0より大きい値をとる．
					//しかし，0~1の値がほしいのでclampを使います
					ret = t1;
 				}
				else if(i.uv.x < 3.0/ 5.0){ // part3
					float edge0 = 0.45;
					float edge1 = 0.55;
					float t = clamp((i.uv.y - edge0)/(edge1 - edge0), 0.0, 1.0);
					float t1 = 3.0*t*t - 2.0*t*t*t;
					//線形でなくなめらかにする．
					ret = t1;
				}
				else if(i.uv.x < 4.0/5.0){ // part4
					ret = smoothstep(0.45, 0.55, i.uv.y);
				}
				else if(i.uv.x < 5.0/5.0){
					float edge0 = 0.45;
					float edge1 = 0.55;
					float t = clamp((i.uv.y - edge0)/(edge1 - edge0), 0.0, 1.0);
					float t1 = t*t*t*(t*(t*6.0 - 15.0) + 10.0);
					ret = t1;
				}


				pixel = fixed3 (ret, ret, ret);
				return fixed4(pixel, 1.0);
			}


			ENDCG
		}
	}
}
