# DER Encoding for Mathemtica 9.0
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
In[3]:= StringJoin[ToUpperCase[IntegerString[DEREncoding[{r,s}],16]]]
Out[3]= 304522076CAAD0DBBFA4C0949D275A839885804A9795D6459D5AC293ACBE1FE3FEAB2210968210269B5EEBF5BE6ADAFE23249797C1556E20CFEC65FE21F34F5224F02
```
