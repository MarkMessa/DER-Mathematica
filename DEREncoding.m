(*
DER Encoding format for Mathematica 9.0
Package for converting the ECDSA signature from the standard {r, s} format to the DER encoding.
*)

BeginPackage["DEREncoding`"];
	DEREncoding::usage="DEREncoding[{r, s}] returns the digital signature in the DER encoding format. The input r and s are a list of integers (from 0 to 255) and the output is also a list of integers (from 0 to 255).";

	Begin["`Private`"];

		DEREncoding[{r_,s_}]:=Module[{p={r,s}},

			Do[
				(* delete leading zeros *)
				While[p[[i]]!={}&&p[[i,1]]==0,p[[i]]=Delete[p[[i]],1]];

				(* include leading zero if first bit is 1 *)
				If[First[IntegerDigits[p[[i,1]],2,8]]==1,p[[i]]=Join[{0},p[[i]]];];

				(* include header byte 0x02 indicating integer and 1-byte length descriptor *)
				p[[i]]=Join[{02,Length[p[[i]]]},p[[i]]];
				,
				{i,2}
			];

			p=Flatten[p];

			(* include header byte 0x30 indicating compound structure and 1-byte length descriptor for all what follows *)
			p=Join[{48,Length[p]},p];

			Return[p]
		]

	End[];
EndPackage[];
