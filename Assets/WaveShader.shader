//UNITY_SHADER_NO_UPGRADE

Shader "Unlit/WaveShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Pass
		{
			Cull Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;	

			struct vertIn
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct vertOut
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			// Implementation of the vertex shader
			vertOut vert(vertIn v)

			{
				
				// Displace the original vertex in model space
				//Pregunta 1: Jala shader al material
				//Pregunta 2: float4 displacement = float4(0.0f, 1.0f, 0.0f, 0.0f);
				//Pregunta 2.1: float4 displacement = float4(0.0f, 1.0f, 0.0f, 0.0f) * _Time.y;
				//Pregunta 2.2: float4 displacement = float4(0.0f, 1.0f, 0.0f, 0.0f) * _SinTime.y;
				// Pregunta 3:float4 displacement = float4(0.0f, 1.0f, 0.0f, 0.0f) * sin(v.vertex.x);
				//Pregunta 4: float4 displacement = float4(0.0f, 1.0f, 0.0f, 0.0f) * sin(v.vertex.x + _Time.y);
				//Pregunta 5.1: float4 displacement = float4(0.0f, 0.5f, 0.0f, 0.0f) * sin(v.vertex.x + _Time.y);
				//Pregunta 5.2: float4 displacement = float4(0.0f, 0.5f, 0.0f, 0.0f) * sin(v.vertex.x + (_Time.y*4));
				//Pregunta 5.3: float4 displacement = float4(0.0f, 0.5f, 0.0f, 0.0f) * sin(v.vertex.x + pow(_Time.y, 2));
				//float4 displacement = float4(0.0f, 0.5f, 0.0f, 0.0f) * sin(v.vertex.x + (_Time.y*4));
				float4 displacement = float4(0.0f, 0.0f, 0.0f, 0.0f);
				v.vertex += displacement;
				

				vertOut o;

				float4 viewSpace = mul(UNITY_MATRIX_MV, v.vertex);

				//viewSpace.y += sin(_Time.y);

				viewSpace.y += sin(v.vertex.y + viewSpace);
				

				o.vertex = mul(UNITY_MATRIX_P, viewSpace);
				o.uv = v.uv;
				return o;
			}
			
			// Implementation of the fragment shader
			fixed4 frag(vertOut v) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, v.uv);
				return col;
			}
			ENDCG
		}
	}
}