# DER Encoding for Mathematica 9.0
##Overview
Package for converting the ECDSA signature from the standard {r, s} format to the DER encoding. The main function is:
- DEREncoding[{r, s}] returns the digital signature in the DER encoding format. The input r and s are a list of integers (from 0 to 255) and the output is also a list of integers (from 0 to 255).

A simple usage example:
```Mathematica
(* Load Package *)
In[1]:= Get[FileNameJoin[{NotebookDirectory[], "DEREncoding.m"}]]

(* Generation of a random signature {r,s} *)
In[2]:= {r,s}=Table[RandomInteger[255],{2},{32}]
Out[2]= {{118,202,10,208,219,191,10,4,192,148,157,39,90,131,152,133,128,74,151,149,214,69,157,90,194,147,172,190,31,227,254,171},{150,130,16,38,155,5,238,191,5,190,106,218,254,35,36,151,151,193,85,110,32,207,236,101,254,33,243,79,82,36,240,2}}

(* Encoding to DER format *)
In[3]:= DEREncoding[{r,s}]
Out[3]= {48,69,2,32,118,202,10,208,219,191,10,4,192,148,157,39,90,131,152,133,128,74,151,149,214,69,157,90,194,147,172,190,31,227,254,171,2,33,0,150,130,16,38,155,5,238,191,5,190,106,218,254,35,36,151,151,193,85,110,32,207,236,101,254,33,243,79,82,36,240,2}

(* Visualizing the DER encoding output into the more usual hexadecimal format *)
In[4]:= StringJoin[ToUpperCase[IntegerString[DEREncoding[{r,s}],16,2]]]
Out[4]= 3045022076CA0AD0DBBF0A04C0949D275A839885804A9795D6459D5AC293ACBE1FE3FEAB022100968210269B05EEBF05BE6ADAFE23249797C1556E20CFEC65FE21F34F5224F002
```

##DER Encoding Format
ECDSA signatures exhibits an structure like {r-coordinate INTEGER, s-coordinate INTEGER} and, when encoded in DER, this becomes the following sequence of bytes:

`[0x30] [total-length] [0x02] [r-length] [r-coordinate] [0x02] [s-length] [s-coordinate]`

where:

- `[0x30]` header byte indicating a compound structure.
- `[total-length]` 1-byte length descriptor for all what follows.
- `[0x02]` header byte indicating an integer.
- `[r-length]` 1-byte length descriptor for the r value that follows.
- `[r-coordinate]` big-endian integer of 'minimum length'.
- `[0x02]` header byte indicating an integer.
- `[s-length]` 1-byte length descriptor for the s value that follows.
- `[s-coordinate]` big-endian integer of 'minimum length'.

The 'minimum length' means that an initial `0x00` byte for r and s is not allowed, except when their highest bit is set (ie. when the first byte is above `0x7F`, a single `0x00` in front is required).
What happens is that the highest bit specifies the sign of the value. However, for ECDSA the r and s values are positive integers, so the highest bit must not be set.

This results in 71 bytes signatures (on average), as there are several header bytes, and the r and s values are variable length. Some examples:

**Case 1**
```
r-coordinate: 96A004E70C9861A401A171BCA505C194572D07829FE454A4359636C275491EDF
s-coordinate: DF697AA4C0359A49B4EE72195225A6CD80E51A5C104227279E5FD9E3A6A396C4
DER encoding: 304602210096A004E70C9861A401A171BCA505C194572D07829FE454A4359636C275491EDF022100DF697AA4C0359A49B4EE72195225A6CD80E51A5C104227279E5FD9E3A6A396C4
```

**Case 2**
```
r-coordinate: 6976E94023686FC74FB4FE53E8C8AF91C46FBF0CFB4AD171391531965C3F2B1E
s-coordinate: 0BCEA5D246296AD9F82231B31F2F25693A25DCC64FCB4A5FCE8319BC2096F2CB
DER encoding: 304402206976E94023686FC74FB4FE53E8C8AF91C46FBF0CFB4AD171391531965C3F2B1E02200BCEA5D246296AD9F82231B31F2F25693A25DCC64FCB4A5FCE8319BC2096F2CB
```

**Case 3**
```
r-coordinate: CFB8CDB40A2875581BF6D3477D63E7673F61C5023D4B1611DA6B7FFA824D7CA5
s-coordinate: 33DDD9E246B653D9DE27E595330A24CA10270D462CA9880C62C7BFB2D8FF7F61
DER encoding: 3045022100CFB8CDB40A2875581BF6D3477D63E7673F61C5023D4B1611DA6B7FFA824D7CA5022033DDD9E246B653D9DE27E595330A24CA10270D462CA9880C62C7BFB2D8FF7F61
```
**Case 4**
```
r-coordinate: B39677D31D0D2692F29D386DC23C44163C84353A977362376669181FCCD27C4B
s-coordinate: 9B5D778A3412369F7693910D1B9235D8AA5E94CFA62B49A413EE9EE9C9B8061B
DER encoding: 3046022100B39677D31D0D2692F29D386DC23C44163C84353A977362376669181FCCD27C4B0221009B5D778A3412369F7693910D1B9235D8AA5E94CFA62B49A413EE9EE9C9B8061B
```

**Case 5**
```
r-coordinate: 506827C63CEAD16598A9903A0718CC986CE40D01982B39674ED89EBACA4ADE5A
s-coordinate: 93424B0E424324A2AFE48831D537A7DEE22EAAE3504CFBBD3175A1A4B9B30E29
DER encoding: 30450220506827C63CEAD16598A9903A0718CC986CE40D01982B39674ED89EBACA4ADE5A02210093424B0E424324A2AFE48831D537A7DEE22EAAE3504CFBBD3175A1A4B9B30E29
```
