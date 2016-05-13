Shader "Custom/SpriteSheetShader" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		_TexWidth ("Sprite Width",float) = 0.0
		_CellAmount ("Cell Amount",int ) = 0
		_Speed ("Speed",Range(0.01,32)) = 12
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		float _TexWidth;
		int _CellAmount;
		float _Speed;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutputStandard o) {
			//Lets store our UVs in a seperate variable
			float2 spriteUV = IN.uv_MainTex;

			//Lets calculate the width of a singe cell in our
			//sprite sheet and get a uv percentage that each cel takes up.
			float cellPixelWidth = _TexWidth/_CellAmount;
			float cellUVPercentage = cellPixelWidth/_TexWidth;
			
			//Lets get a stair step value out of time so we can increment
			//the uv offset
			float timeVal = fmod(_Time.y * _Speed, _CellAmount);
			timeVal = ceil(timeVal);
			
			//Animate the uv's forward by the width precentage of 
			//each cell
			float xValue = spriteUV.x;
			xValue += cellUVPercentage * timeVal * _CellAmount;
			xValue *= cellUVPercentage;
			
			spriteUV = float2(xValue, spriteUV.y);
		
			half4 c = tex2D (_MainTex, spriteUV);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
