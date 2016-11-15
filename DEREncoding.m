(*
DER Encoding format for Mathematica 9.0
Package for converting the ECDSA signature from the standard {r, s} format to the DER encoding.
*)

BeginPackage["DEREncoding`"];
	DEREncoding::usage="DEREncoding[{r, s}] returns the ECDSA signature {r, s} in the DER encoding format. The input r and s are a list of strings representing hexadecimal numbers (from 0x00 to 0xFF) and the output is also a list of strings (from 0x00 to 0xFF).";

	Begin["`Private`"];

		DEREncoding[{r_,s_}]:=Module[{p={r,s}},

			Do[
				(* delete leading zeros *)
				While[p[[i]]!={}&&p[[i,1]]==0,p[[i]]=Delete[p[[i]],1]];

				(* include leading zero if first bit is 1 *)
				If[First[IntegerDigits[FromDigits[p[[i,1]],16],2,8]]==1,p[[i]]=Join[{"00"},p[[i]]];];

				(* include header byte 0x02 indicating integer and 1-byte length descriptor *)
				p[[i]]=Join[{"02",IntegerString[Length[p[[i]]],16,2]},p[[i]]];
				,
				{i,2}
			];

			p=Flatten[p];

			(* include header byte 0x30 indicating compound structure and 1-byte length descriptor for all what follows *)
			p=Join[{"30",IntegerString[Length[p],16,2]},p];

			Return[p]
		]

	End[];
EndPackage[];
