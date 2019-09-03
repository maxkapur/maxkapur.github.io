import numpy as np
from itertools import product, permutations

# Yields all the square matrices of a given n whose entries are 0 or 1.
def Hadamard(n):
  h= np.array(list(product(range(2),repeat=(n*2))))
  h.reshape(len(h),n,n)
  return(h)

# Yields all permutation matrices of a given n
def permmat(n):
  perms= list(permutations(range(n)))
  blank= np.zeros((n,n))
  out= []
  for i in perms:
    w = []
    for j in i:
      w.append(np.arange(n) == j)
    out.append(w)
  #  for i in perms:
  #    m = blank
  #    for j in range(n):
  #      m[j,i[j]] = 1
  #    out.append(m)
  out = np.array(out).astype(int)
  return(out)

# Yields cofactor matrix as defined in Strang
# C[i,j] = -1^(i+j) det M_ij
def cofactor(matrix):
  n = len(matrix)
  out = np.zeros((n,n))
  for i in range(n):
    for j in range(n):
      M = matrix
      M = np.delete(M, i, axis=0)
      M = np.delete(M, j, axis=1)
      out[i,j]=np.linalg.det(M)*(-1)**(i+j)
  return(out)    

