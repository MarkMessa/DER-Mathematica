# DER Encoding for Mathematica 9.0
##Overview
Package for converting the ECDSA signature from the standard {r, s} format to the DER encoding. The main function is:
- DEREncoding[{r, s}] returns the digital signature in the DER encoding format. The input r and s are a list of integers (from 0 to 255) and the output is also a list of integers (from 0 to 255).

A simple usage example:
```Mathematica
(* Generation of a random signature {r,s} *)
In[1]:= {r,s}=Table[RandomInteger[255],{2},{32}]
Out[1]= {{118,202,10,208,219,191,10,4,192,148,157,39,90,131,152,133,128,74,151,149,214,69,157,90,194,147,172,190,31,227,254,171},{150,130,16,38,155,5,238,191,5,190,106,218,254,35,36,151,151,193,85,110,32,207,236,101,254,33,243,79,82,36,240,2}}

(* Encoding to DER format *)
In[2]:= DEREncoding[{r,s}]
Out[2]= {48,69,2,32,118,202,10,208,219,191,10,4,192,148,157,39,90,131,152,133,128,74,151,149,214,69,157,90,194,147,172,190,31,227,254,171,2,33,0,150,130,16,38,155,5,238,191,5,190,106,218,254,35,36,151,151,193,85,110,32,207,236,101,254,33,243,79,82,36,240,2}

(* Visualizing the DER encoding output into the more usual hexadecimal format *)
In[3]:= StringJoin[ToUpperCase[IntegerString[DEREncoding[{r,s}],16,2]]]
Out[3]= 3045022076CA0AD0DBBF0A04C0949D275A839885804A9795D6459D5AC293ACBE1FE3FEAB022100968210269B05EEBF05BE6ADAFE23249797C1556E20CFEC65FE21F34F5224F002
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

This results on average in 71 bytes signatures, as there are several header bytes, and the r and s values are variable length. Some examples:
