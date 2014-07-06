DEF SDIF_API = ""
DEF MaxUserData = 10

IF UNAME_SYSNAME == "Windows":
    DEF DBL_MAX = 1.7976931348623157e+308
ELIF UNAME_SYSNAME == "Darwin":
    DEF DBL_MAX = 1.7976931348623157e+308
ELIF UNAME_SYSNAME == "Linux":
    DEF DBL_MAX = 1.7976931348623157e+308

DEF FLT_EPSILON = 10^(-5)

#cdef inline unsigned int sig2uint (char *sig):
#   return ((((<unsigned int>(sig[0])) & 0xff) << 24) | 
#       (((<unsigned int>(sig[1])) & 0xff) << 16) | 
#       (((<unsigned int>(sig[2])) & 0xff) << 8) | 
#       ((<unsigned int>(sig[3])) & 0xff))

from stdio cimport *

cdef extern from 'sdif.h':
    ctypedef char* const_char_ptr "const char*"
    ctypedef unsigned int const_unsigned_int "const unsigned int"
    ctypedef void* const_void_ptr "const void*"
    ctypedef int const_int "const int"


    #ifdef HAVE_STDINT_H
    #include <stdint.h>
    #endif
    #include <stdio.h>
    #include <stdlib.h>
    #include <float.h>

    #if defined (SDIF_IS_STATIC) || defined(EASDIF_IS_STATIC)
    #  define SDIF_API
    #else 
    # ifdef WIN32
    #   ifdef DO_EXPORT_SDIF
    #     define SDIF_API __declspec(dllexport)
    #   else
    #     define SDIF_API __declspec(dllimport)
    #   endif
    #  else
    #    if defined(__GNUC__) && defined( GCC_HAS_VISIBILITY)
    #      define SDIF_API __attribute__ ((visibility("default")))
    #    else
    #      define SDIF_API
    #    endif
    #  endif
    #endif


    #/* forward declaration of big SDIF file struct type */
    #typedef struct SdifFileS SdifFileT;

    #ctypedef struct SdifFileS SdifFileT
    cdef struct SdifFileS
    ctypedef SdifFileS SdifFileT


    #/* SdifHash.h */
    #typedef enum SdifHashIndexTypeE
    #{
    #  eHashChar,
    #  eHashInt4
    #} SdifHashIndexTypeET;
    cdef enum SdifHashIndexTypeE:
        eHashChar,
        eHashInt4
    ctypedef SdifHashIndexTypeE SdifHashIndexTypeET

    #typedef union SdifHashIndexU SdifHashIndexUT;

    #union SdifHashIndexU
    #{
    #  char* Char[1]; /* tab of one pointer to fixe union size at 4 or 8 bytes */
    #  unsigned int  Int4;
    #} ;
    cdef union SdifHashIndexU:
        char* Char[1]
        unsigned int Int4
    ctypedef SdifHashIndexU SdifHashIndexUT

    # --------------------------------------------------------------------------
    # 
    # 
    # 
    # typedef struct SdifHashNS SdifHashNT;
    # 
    # /* hash bin struct, containing linked list of entries */
    # struct SdifHashNS 
    # {
    #   SdifHashNT *Next;   /* pointer to next entry */
    #   SdifHashIndexUT Index;
    #   void* Data;
    # };

    cdef struct SdifHashNS
    ctypedef SdifHashNS SdifHashNT
    cdef struct SdifHashNS:
        SdifHashNT *Next    ## pointer to next entry 
        SdifHashIndexUT Index
        void * Data
        
        
    # 
    # typedef struct SdifHashTableS SdifHashTableT;
    # 
    # struct SdifHashTableS
    # {
    #   SdifHashNT* *Table;     /* table of pointers to hash bins */
    #   unsigned int HashSize;  /* number of hash bins */
    #   SdifHashIndexTypeET IndexType;
    #   void (*Killer)(void *); 
    #   unsigned int NbOfData;  /* total number of entries */
    # } ;
    # 

    cdef struct SdifHashTableS:
        SdifHashNT* *Table      # /* table of pointers to hash bins */
        unsigned int HashSize   # /* number of hash bins */
        SdifHashIndexTypeET IndexType
        #void (*Killer)(void *) 
        void Killer(void *)     # function pointer
        unsigned int NbOfData   # /* total number of entries */
    ctypedef SdifHashTableS SdifHashTableT

    # typedef struct SdifHashTableIteratorS SdifHashTableIteratorT;
    # 
    # struct SdifHashTableIteratorS
    # {
    #   SdifHashTableT *HTable; /* pointer to hash table         */
    #   unsigned int    BinIndex;   /* index of current hash bin         */
    #   SdifHashNT     *Entry;  /* pointer to current hash entry in list */
    # };
    # 
    cdef struct SdifHashTableIteratorS:
        SdifHashTableT *HTable      #/* pointer to hash table        */
        unsigned int    BinIndex    #/* index of current hash bin        */
        SdifHashNT     *Entry       #/* pointer to current hash entry in list */
    ctypedef SdifHashTableIteratorS SdifHashTableIteratorT
    
    # /*
    # //FUNCTION GROUP: File positioning
    # */
    # 
    # /* SdifFile.c */
    # 
    # /*DOC:
    #   Rewind to start of file (before header!) 
    #   [return] 1 on success, 0 on error
    # */
    # SDIF_API int SdifFRewind(SdifFileT *file);
    cdef int SdifFRewind(SdifFileT *file)
    
    # 
    # 
    # #define SDIFFTRUNCATE_NOT_AVAILABLE -2
    # /*DOC:
    #   Truncate file at current position
    #   This function is only available on certain systems that have the
    #   ftruncate function in their system libraries. 
    #   [return] 1 on success, 0 for error (check errno),  
    #         MACRO SDIFFTRUNCATE_NOT_AVAILABLE if function is not available.
    # */
    # SDIF_API int SdifFTruncate(SdifFileT *file);
    # cdef int SdifFTruncate(SdifFileT *file)
    # 
    # 
    # 
    # /* Give documentation and fake prototype for positioning macros.
    #    Cocoon ignores the #if 0.
    # */
    # #if 0
    # 
    # /*DOC:
    #   Get position in file.
    #   [return] file offset or -1 for error.
    #   SdiffPosT is actually long.
    #  */
    # int SdiffGetPos(SdifFileT *file, SdiffPosT *pos);
    #   cdef int SdiffGetPos(SdifFileT *file, SdiffPosT *pos)
    # 
    # /*DOC:
    #   Set absolute position in file.
    #   SdiffPosT is actually long.
    #   [Return] 0 on success, 
    #           -1 on error (errno is set, see fseek(3) for details)
    # 
    #   On Mac or Windows, seeking on a stream is always considered
    #   successful (return 0), even if no seek was done!
    #  */
    # int SdiffSetPos(SdifFileT *file, SdiffPosT *pos);
    # 
    # #endif  /* if 0 */
    # 
    # 
    # /* to do fpos_t compatible on MacinTosh */
    # #if defined(MACINTOSH) || defined(WIN32)
    #     /* on mac or windows, seeking on a stream is always considered
    #        successful (return 0)! */
    # #   define SdiffPosT            long
    ctypedef long SdiffPosT
    # #   define SdiffIsFile(f)       ((f)!=stdin && (f)!=stdout && (f)!=stderr)
    cdef int SdiffIsFile(SdifFileT *f)
    # #   define Sdiffftell(f)        (SdiffIsFile(f)  ?  ftell(f)  :  0)
    cdef int Sdiffftell(SdifFileT *f)
    # #   define SdiffGetPos(f,p)     ((*(p) = Sdiffftell(f)) == -1  ?  -1  :  0)
    cdef int SdiffGetPos(SdifFileT *f, SdiffPosT *p)
    # #   define SdiffSetPos(f,p)     (SdiffIsFile(f)  \
    #                                     ?  fseek(f, (long)(*(p)), SEEK_SET)  :  0)
    cdef int SdiffSetPos(SdifFileT *f, SdiffPosT *p)
    # #else
    # /*
    # #   define SdiffPosT            fpos_t
    # #   define SdiffGetPos(f,p)     fgetpos((f),(p))
    # #   define SdiffSetPos(f,p)     fsetpos((f),(p))
    # 
    # #   define SdiffGetPos(f,p)     ((*(p) = ftell(f)) == -1  ?  -1  :  0)
    # #   define SdiffSetPos(f,p)     (fseek(f, (long)(*(p)), SEEK_SET))
    # */
    # 
    # /*DS: FORCE long fpos*/
    # /* ftell/fseek can be applied to stdin/out/err at least in a restricted manner
    #  * (same as fgetpos/fsetpos) so let's try */
    # #   define SdiffPosT            long
    # #   define SdiffGetPos(f,p)     ((*(p) = ftell(f)) == -1  ?  -1  :  0)
    # #   define SdiffSetPos(f,p)     (fseek(f, (long)(*(p)), SEEK_SET))
    # #endif
    # 
    # 
    # 
    # /*DOC:
    #   Get position in file.
    #   [return] file offset or -1 for error.
    #   SdiffPosT is actually long.
    #  */
    # SDIF_API int SdifFGetPos(SdifFileT *file, SdiffPosT *pos);
    cdef int SdifFGetPos(SdifFileT *file, SdiffPosT *pos)
    # 
    # /*DOC:
    #   Set absolute position in file.
    #   SdiffPosT is actually long.
    #   [Return] 0 on success, 
    #           -1 on error (errno is set, see fseek(3) for details)
    # 
    #   On Mac or Windows, seeking on a stream is always considered
    #   successful (return 0), even if no seek was done!
    #  */
    # SDIF_API int SdifFSetPos(SdifFileT *file, SdiffPosT *pos);
    cdef int SdifFSetPos(SdifFileT *file, SdiffPosT *pos)
    # 
    # 
    # 
    # 
    # /* SdifHard_OS.h */
    # #ifdef HAVE_STDINT_H
    # typedef char           SdifChar;
    # typedef char           SdifInt1;
    # typedef int16_t        SdifInt2;
    # typedef int32_t        SdifInt4;
    # typedef unsigned char  SdifUInt1;
    # typedef uint16_t       SdifUInt2;
    # typedef uint32_t       SdifUInt4;
    # #else
    # typedef char           SdifChar;
    # typedef char           SdifInt1;
    # typedef short          SdifInt2;
    # typedef unsigned char  SdifUInt1;
    # typedef unsigned short SdifUInt2;
    # typedef int            SdifInt4;
    # typedef unsigned int   SdifUInt4;
    # #endif
    ctypedef char           SdifChar;
    ctypedef char           SdifInt1;
    ctypedef short          SdifInt2;
    ctypedef unsigned char  SdifUInt1;
    ctypedef unsigned short SdifUInt2;
    ctypedef int            SdifInt4;
    ctypedef unsigned int   SdifUInt4;
    
    # 
    # typedef SdifUInt4      SdifSignature;
    # typedef float          SdifFloat4;
    # typedef double         SdifFloat8;

    ctypedef SdifUInt4      SdifSignature;
    ctypedef float          SdifFloat4;
    ctypedef double         SdifFloat8;

    # 
    # typedef enum SdifMachineE
    # {
    #   eUndefinedMachine,
    #   eBigEndian,
    #   eLittleEndian,
    #   eBigEndian64,
    #   eLittleEndian64,
    #   ePDPEndian
    # } SdifMachineET;
    # 
    cdef enum SdifMachineE:
        eUndefinedMachine,
        eBigEndian,
        eLittleEndian,
        eBigEndian64,
        eLittleEndian64,
        ePDPEndian
    ctypedef SdifMachineE SdifMachineET
    
    # typedef enum SdifBinaryMode
    # {
    #   eBinaryModeUnknown,
    #   eBinaryModeWrite,
    #   eBinaryModeRead,
    #   eBinaryModeReadWrite,
    #   eBinaryModeStdInput,
    #   eBinaryModeStdOutput,
    #   eBinaryModeStdError
    # } SdifBinaryModeET ;
    # 
    cdef enum SdifBinaryMode:
        eBinaryModeUnknown,
        eBinaryModeWrite,
        eBinaryModeRead,
        eBinaryModeReadWrite,
        eBinaryModeStdInput,
        eBinaryModeStdOutput,
        eBinaryModeStdError,
    ctypedef SdifBinaryMode SdifBinaryModeET ;
        #
    # /* SdifGlobals.h */
    # /* DOC:
    # 
    #   Macro to generate an integer representation of the sequence of unsigned chars 
    #   for example :
    # 
    #   SdifSignature sig=SdifSignatureConst('A','B','C','D');
    # 
    #   Because integers are differently handled on little/big endian machines the
    #   signatures are swapped if read from a file to match internal format. */
    #   
    # #   define SdifSignatureConst(p1,p2,p3,p4) (((((unsigned int)(p1))&0xff)<<24)|((((unsigned int)(p2))&0xff)<<16)|((((unsigned int)(p3))&0xff)<<8)|(((unsigned int)(p4))&0xff))
    # 
    cdef unsigned int SdifSignatureConst(char p1, char p2, char p3, char p4)
    
            
    # 
    # #ifndef SWIG
    # typedef enum SdifSignatureE
    # {
    #   eSDIF = SdifSignatureConst('S','D','I','F'), /* SDIF header */
    #   e1NVT = SdifSignatureConst('1','N','V','T'), /* Name Value Table */
    #   e1TYP = SdifSignatureConst('1','T','Y','P'), /* TYPe declarations */
    #   e1MTD = SdifSignatureConst('1','M','T','D'), /* Matrix Type Declaration */
    #   e1FTD = SdifSignatureConst('1','F','T','D'), /* Frame Type Declaration */
    #   e1IDS = SdifSignatureConst('1','I','D','S'), /* ID Stream Table */
    #   eSDFC = SdifSignatureConst('S','D','F','C'), /* Start Data Frame Chunk (text files) */
    #   eENDC = SdifSignatureConst('E','N','D','C'), /* END Chunk (text files) */
    #   eENDF = SdifSignatureConst('E','N','D','F'), /* END File (text files) */
    #   eFORM = SdifSignatureConst('F','O','R','M'), /* FORM for IFF compatibility (obsolete ?) */
    #   eEmptySignature = SdifSignatureConst('\0','\0','\0','\0')
    # } SdifSignatureET;
    # #endif
    # 
    cdef enum SdifSignatureE:
        eSDIF = 1396984064,
        e1NVT = 827217408,
        e1TYP = 827611392,
        e1MTD = 827151360,
        e1FTD = 826692608,
        e1IDS = 826885120,
        eEmptySignature = 0
    ctypedef SdifSignatureE SdifSignatureET
    
    # typedef enum SdifModifModeE
    # {
    #   eNoModif,
    #   eCanModif
    # } SdifModifModeET;
    # 
    cdef enum SdifModifModeE:
        eNoModif,
        eCanModif
    ctypedef SdifModifModeE SdifModifModeET
    # 
    # /* DataTypeEnum
    # 
    #    On Matt Wright's visit at IRCAM June 1999, we defined a new
    #    encoding for the MatrixDataType field with the feature that the low
    #    order byte encodes the number of bytes taken by each matrix
    #    element.  
    # 
    #    Low order byte encodes the number of bytes 
    #    High order bytes come from this (extensible) enum:
    # 
    #         0 : Float
    #         1 : Signed integer
    #         2 : Unsigned integer
    #         3 : Text (UTF-8 when 1 byte)
    #         4 : arbitrary/void
    # */
    # typedef enum SdifDataTypeE
    # {
    #   eText     = 0x0301,
    #   eChar     = 0x0301,
    #   eFloat4   = 0x0004,
    #   eFloat8   = 0x0008,
    #   eInt1     = 0x0101,
    #   eInt2     = 0x0102,
    #   eInt4     = 0x0104,
    #   eInt8     = 0x0108,
    #   eUInt1    = 0x0201,
    #   eUInt2    = 0x0202,
    #   eUInt4    = 0x0204,
    #   eUInt8    = 0x0208,
    #             
    #   eFloat4a  = 0x0001,   /* =  1 */    /* Backwards compatibility with old */
    #   eFloat4b  = 0x0020,   /* = 32 */    /* IRCAM versions < 3 of SDIF */
    #   eFloat8a  = 0x0002,   /* =  2 */    /* IN TEXT MODE ONLY! */
    #   eFloat8b  = 0x0040    /* = 64 */
    # } SdifDataTypeET;
    # 
    cdef enum SdifDataTypeE:
        eText   = 0x0301,
        eChar   = 0x0301,
        eFloat4   = 0x0004,
        eFloat8   = 0x0008,
        eInt1     = 0x0101,
        eInt2     = 0x0102,
        eInt4     = 0x0104,
        eInt8     = 0x0108,
        eUInt1    = 0x0201,
        eUInt2    = 0x0202,
        eUInt4    = 0x0204,
        eUInt8    = 0x0208,
              
        eFloat4a  = 0x0001,#   /* =  1 */    /* Backwards compatibility with old */
        eFloat4b  = 0x0020, #   /* = 32 */    /* IRCAM versions < 3 of SDIF */
        eFloat8a  = 0x0002, #   /* =  2 */    /* IN TEXT MODE ONLY! */
        eFloat8b  = 0x0040, #   /* = 64 */
    ctypedef SdifDataTypeE SdifDataTypeET
    
    # /* SdifList.h */
    # typedef void (*KillerFT) (void *);
    # 
    # typedef struct SdifListNS SdifListNT;
    cdef struct SdifListNS
    ctypedef SdifListNS SdifListNT
    cdef struct SdifListNS:
        SdifListNT *Next
        void *Data
    
    # 
    # struct SdifListNS 
    # {
    #   SdifListNT *Next;
    #   void* Data;
    # };
    # 
    # 
    # typedef struct SdifListNStockS SdifListNStockT;
    # 
    # struct SdifListNStockS
    # {
    #     SdifListNT*  StockList; /* list of arrays of nodes, the first node is used to chain arrays */
    #     unsigned int SizeOfOneStock; /* must be > 1 */
    #     unsigned int NbStock;
    # 
    #     unsigned int NbNodesUsedInCurrStock;
    # 
    #     SdifListNT* Trash; /* to recycle nodes */
    # };
    struct SdifListNStockS
        SdifListNT*  StockList; /* list of arrays of nodes, the first node is used to chain arrays */
        unsigned int SizeOfOneStock; /* must be > 1 */
        unsigned int NbStock;
        unsigned int NbNodesUsedInCurrStock;
        SdifListNT* Trash; /* to recycle nodes */
    ctypedef SdifListNStockS SdifListNStockT
    # 
    # 
    # /* lists management */
    # 
    # typedef struct SdifListS SdifListT;
    # typedef SdifListT       *SdifListP;
    # 
    # struct SdifListS
    # {
    #   /* fifo list */
    #   SdifListNT *Head;
    #   SdifListNT *Tail;
    #   SdifListNT *Curr;  /* pointer before the next */
    #   void (*Killer)(void *);  
    #   unsigned int NbData;
    # } ;
    # 
    cdef struct SdifListS:
        pass
    ctypedef SdifListS SdifListT
    ctypedef SdifListT* SdifListP

    # /* SdifNameValue.h */
    # typedef struct SdifNameValueS SdifNameValueT;
    # struct SdifNameValueS
    # {
    #   char *Name;
    #   char *Value;
    # } ;

    cdef struct SdifNameValueS:
        char *Name
        char *Value
    ctypedef SdifNameValueS SdifNameValueT

    # 
    # typedef struct SdifNameValueTableS SdifNameValueTableT;
    # struct SdifNameValueTableS
    # {
    #     SdifHashTableT* NVHT;
    #     SdifUInt4       NumTable;
    #     SdifUInt4       StreamID;   /* id of stream the table belongs to */
    # } ;

    cdef SdifNameValueTableS:
        SdifHashTableT* NVHT
        SdifUInt4 NumTable
        SdifUInt4 StreamID
    ctypedef SdifNameValueTableS SdifNameValueTableT

    # 
    # typedef struct SdifNameValuesLS SdifNameValuesLT;
    # struct SdifNameValuesLS
    # {
    #     SdifListT*              NVTList;  /* list of SdifNameValueTableT */
    #     SdifNameValueTableT*    CurrNVT;
    #     SdifUInt4               HashSize;
    # };
    cdef struct SdifNameValuesLS:
        SdifListT*  NVTList
        SdifNameValueTableT*    CurrNVT
        SdifUInt4   HashSize
    ctypedef SdifNameValuesLS SdifNameValuesLT
    # 
    # 
    # /* SdifStreamID.h */
    # 
    # /*
    # // DATA GROUP:          Stream ID Table and Entries for 1IDS ASCII chunk
    # */
    # 
    # 
    # /*DOC:
    #   Stream ID Table Entry */
    # typedef struct SdifStreamIDS SdifStreamIDT;
    # struct SdifStreamIDS
    # {
    #   SdifUInt4     NumID;
    #   char *Source;
    #   char *TreeWay; /* for the moment or to be general*/
    # } ;
    cdef struct SdifStreamIDS:
        SdifUInt4 NumID
        char *Source
        char *TreeWay
    ctypedef SdifStreamIDS SdifStreamIDT
    # 
    # /*DOC:
    #   Stream ID Table, holds SdifStreamIDT stream ID table entries */
    # typedef struct SdifStreamIDTableS SdifStreamIDTableT;
    # struct SdifStreamIDTableS
    # {
    #     SdifHashTableT* SIDHT;
    #     SdifUInt4       StreamID;
    #     SdifFloat8      Time;       /* always _SdifNoTime */
    # } ;
    struct SdifStreamIDTableS:
        SdifHashTableT* SIDHT
        SdifUInt4       StreamID
        SdifFloat8      Time #       /* always _SdifNoTime */
    ctypedef SdifStreamIDTableS SdifStreamIDTableT
    # 
    # 
    # typedef struct SdifColumnDefS SdifColumnDefT;
    # 
    # struct SdifColumnDefS
    # {
    #   char *Name;
    #   SdifUInt4 Num;
    # } ;
    struct SdifColumnDefS:
        char *Name
        SdifUInt4 Num
    ctypedef SdifColumnDefS SdifColumnDefT
    # 
    # 
    # /* SdifMatrixType.h */
    # typedef struct SdifMatrixTypeS SdifMatrixTypeT;
    # 
    # struct SdifMatrixTypeS
    # {
    #   SdifSignature     Signature;
    # 
    #   SdifMatrixTypeT*  MatrixTypePre;
    # 
    #   SdifListT*        ColumnUserList; /* List of columns added by user: 
    #                                        SdifMatrixTypeInsertTailColumn(MatrixTypeT *)
    #                                     */
    # 
    #   SdifUInt4       NbColumnDef; /* Number of columns created by user:
    #                                   SdifMatrixTypeInsertTailColumn(MatrixTypeT *)
    #                                */
    #   SdifModifModeET ModifMode;
    # };
    cdef struct SdifMatrixTypeS
    ctypedef SdifMatrixTypeS SdifMatrixTypeT
    cdef struct SdifMatrixTypeS:
        SdifSignature       Signature
        SdifMatrixTypeT*    MatrixTypePre
        SdifListT*          ColumnUserList
        SdifUInt4           NbColumnDef
        SdifModiModeET      ModifMode
    
    # 
    # 
    # /* SdifFrameType.h */
    # typedef struct SdifComponentS SdifComponentT;
    # struct SdifComponentS
    # {
    #   SdifSignature MtrxS;
    #   char *Name;
    #   SdifUInt4  Num;
    # } ;
    cdef struct SdifComponentS:
        SdifSignature MtrxS
        char *Name
        SdifUInt4 Num
    ctypedef SdifComponentS SdifComponentT
    
    # 
    # typedef struct SdifFrameTypeS SdifFrameTypeT;
    # struct SdifFrameTypeS
    # {
    #   SdifSignature Signature;
    # 
    #   SdifFrameTypeT* FrameTypePre;
    # 
    #   SdifHashTableT *ComponentUseHT;
    #   SdifUInt4       NbComponentUse;
    # 
    #   SdifUInt4       NbComponent;
    #   SdifModifModeET ModifMode;
    # };
    cdef struct SdifFrameTypeS
    ctypedef SdifFrameTypeS SdifFrameTypeT
    cdef struct SdifFrameTypeS:
        SdifSignature Signature;
        
        SdifFrameTypeT* FrameTypePre
        
        SdifHashTableT *ComponentUseHT
        SdifUInt4       NbComponentUse
        
        SdifUInt4       NbComponent
        SdifModifModeET ModifMode
    
    # 
    # 
    # /* SdifMatrix.h */
    # typedef struct SdifMatrixHeaderS SdifMatrixHeaderT;
    # 
    # struct SdifMatrixHeaderS
    # {
    #   SdifSignature  Signature;
    #   SdifDataTypeET DataType; /* Low level data type */
    #   SdifUInt4      NbRow;
    #   SdifUInt4      NbCol;
    # } ;
    cdef struct SdifMatrixHeaderS:
        SdifSignature  Signature
        SdifDataTypeET DataType # /* Low level data type */
        SdifUInt4      NbRow
        SdifUInt4      NbCol
    ctypedef SdifMatrixHeaderS SdifMatrixHeaderT
    
    
    # 
    # 
    # typedef union DataTypeU DataTypeUT;
    # 
    # union DataTypeU
    # {
    #   SdifFloat4 *Float4;
    #   SdifFloat8 *Float8;
    #   SdifInt1   *Int1  ;
    #   SdifInt2   *Int2  ;
    #   SdifInt4   *Int4  ;
    # /*SdifInt8   *Int8  ;*/
    #   SdifUInt1  *UInt1 ;
    #   SdifUInt2  *UInt2 ;
    #   SdifUInt4  *UInt4 ;
    # /*SdifUInt8  *UInt8 ;*/
    #   SdifChar   *Char  ;
    #   void       *Void  ;   /* generic pointer */
    # } ;
    #
    cdef union DataTypeU:
        SdifFloat4 *Float4
        SdifFloat8 *Float8
        SdifInt1   *Int1  
        SdifInt2   *Int2  
        SdifInt4   *Int4  
        SdifUInt1  *UInt1 
        SdifUInt2  *UInt2 
        SdifUInt4  *UInt4 
        SdifChar   *Char  
        void       *Void  #;   /* generic pointer */
    ctypedef DataTypeU DataTypeUT
    # 
    # typedef struct SdifOneRowS SdifOneRowT;
    # 
    # struct SdifOneRowS
    # {
    #   SdifDataTypeET DataType;
    #   SdifUInt4      NbData;
    #   DataTypeUT     Data;
    #   SdifUInt4      NbGranuleAlloc;
    # } ;
    cdef struct SdifOneRowS:
        SdifDataTypeET DataType
        SdifUInt4      NbData
        DataTypeUT     Data
        SdifUInt4      NbGranuleAlloc
    ctypedef SdifOneRowS SdifOneRowT
    
    # 
    # typedef struct SdifMatrixDataS SdifMatrixDataT;
    # struct SdifMatrixDataS
    # {
    #   SdifMatrixHeaderT *Header;
    #   int               ForeignHeader;  /* Header was not allocated by me */
    #   SdifUInt4         Size;       /* byte size of matrix on file */
    #   DataTypeUT        Data;       /* any type pointer to data */
    #   SdifUInt4         AllocSize;  /* allocated size of data in bytes */
    # };
    # 
    cdef struct SdifMatrixDataS:
        SdifMatrixHeaderT *Header
        int               ForeignHeader
        SdifUInt4         Size
        DataTypeUT        Data
        SdifUInt4         AllocSize
    ctypedef SdifMatrixDataS SdifMatrixDataT

    # /* SdifFrame.h */
    # typedef struct SdifFrameHeaderS SdifFrameHeaderT;
    # struct SdifFrameHeaderS
    # {
    #   SdifSignature Signature;
    #   SdifUInt4  Size;
    #   SdifUInt4  NbMatrix;
    #   SdifUInt4  NumID;
    #   SdifFloat8 Time;
    # } ;
    cdef struct SdifFrameHeaderS:
        SdifSignature Signature
        SdifUInt4  Size
        SdifUInt4  NbMatrix
        SdifUInt4  NumID
        SdifFloat8 Time
    ctypedef SdifFrameHeaderS SdifFrameHeaderT
        
    # 
    # 
    # typedef struct SdifFrameDataS SdifFrameDataT;
    # struct SdifFrameDataS
    # {
    #   SdifFrameHeaderT *Header;
    #   SdifMatrixDataT* *Matrix_s;
    # } ;
    cdef struct SdifFrameDataS:
        SdifFrameHeaderT *Header
        SdifMatrixDataT* *Matrix_s
    ctypedef struct SdifFrameDataS SdifFrameDataT
    
    # 
    # 
    # 
    # /* SdifTimePosition.h */
    # typedef struct SdifTimePositionS SdifTimePositionT;
    # 
    # struct SdifTimePositionS
    # {
    #   SdifFloat8    Time;
    #   SdiffPosT     Position;
    # };
    cdef struct SdifTimePositionS:
        SdifFloat8    Time
        SdiffPosT     Position
    ctypedef SdifTimePositionS SdifTimePositionT

    # 
    # 
    # typedef struct SdifTimePositionLS SdifTimePositionLT;
    # 
    # struct SdifTimePositionLS
    # {
    #     SdifListT*          TimePosList;
    # };
    cdef struct SdifTimePositionLS:
        SdifListT*  TimePosList
    ctypedef SdifTimePositionLT
    
    SDIF_API SdifTimePositionT* SdifCreateTimePosition(SdifFloat8 Time, SdiffPosT Position)
    SDIF_API void               SdifKillTimePosition(void* TimePosition)
    SDIF_API SdifTimePositionLT* SdifCreateTimePositionL(void)
    SDIF_API SdifTimePositionLT* SdifCreateTimePositionL(void)
    SDIF_API void                SdifKillTimePositionL  (SdifTimePositionLT *TimePositionL)

    SDIF_API SdifTimePositionLT* SdifTimePositionLPutTail(SdifTimePositionLT* TimePositionL, SdifFloat8 Time, SdiffPosT Position)
    SDIF_API SdifTimePositionT*  SdifTimePositionLGetTail(SdifTimePositionLT* TimePositionL)
    # 
    # 
    # 
    # /* SdifSignatureTab.h */
    struct SdifSignatureTabS:
        SdifUInt4 NbSignMax
        SdifUInt4 NbSign
        SdifSignature* Tab
    ctypedef SdifSignatureTabS SdifSignatureTabT
    # 
    # /* SdifSelect.h */
    # 
    # /* 
    # // DATA GROUP:  SDIF Selection
    # */
    # 
    # /* tokens (numerical ids) for sdifspec separators */
    # typedef enum { sst_specsep, sst_stream, sst_frame, sst_matrix, sst_column, 
    #                sst_row,     sst_time,   sst_list,  sst_range,  sst_delta,
    #                sst_num  /* number of tokens */,    sst_norange = 0
    # } SdifSelectTokens;
    enum SdifSelectTokensE:
        sst_specsep, sst_stream, sst_frame, sst_matrix, sst_column, 
        sst_row,     sst_time,   sst_list,  sst_range,  sst_delta,
        sst_num
    ctypedef SdifSelectTokensE SdifSelectTokens
    # 
    # /*DOC: 
    #   Selection element interface (returned by SdifGetNextSelection*):
    #   One basic data element value, with optional range.  
    #   The meaning of range is determined by rangetype: 
    # 
    #   [] 0          no range
    #   [] sst_range  range is value..range
    #   [] sst_delta  range is value-range..value+range
    # */
    # 
    # typedef struct 
    # {
    #     SdifUInt4          value, range;
    #     SdifSelectTokens   rangetype; /* 0 for not present, sst_range, sst_delta */
    # } SdifSelectElementIntT; 
    ctypedef struct SdifSelectElementIntT:
        SdifUInt4          value, range
        SdifSelectTokens   rangetype # ; /* 0 for not present, sst_range, sst_delta */
    
    # typedef struct 
    # {
    #     double             value, range;
    #     SdifSelectTokens   rangetype; /* 0 for not present, sst_range, sst_delta */
    # } SdifSelectElementRealT;
    # 
    ctypedef struct SdifSelectElementRealT:
        double value, range
        SdifSelectTokens rangetype
        


    # /* no SdifSelectElementSignatureT or string range, since it makes no sense */
    # 
    # 
    # 
    # /*DOC:
    #   Internal: one value of different possible types in a selection
    #   element (the element list determines which type is actually used).  
    # */
    # typedef union SdifSelectValueS 
    # {
    #     SdifUInt4      integer;
    #     double         real;
    #     char           *string;
    #     SdifSignature  signature;
    # } SdifSelectValueT;
    union SdifSelectValueS:
        SdifUInt4      integer
        double         real
        char           *string
        SdifSignature  signature
    ctypedef SdifSelectValueS SdifSelectValueT
    # 
    # /*DOC: 
    #   Selection element internal data structure:
    #   One basic data element, with optional <ul>
    #   <li> range (value is lower, range is upper bound) or 
    #   <li> delta (value-range is lower, value+range is upper bound)
    #   </ul>
    # */
    # typedef struct SdifSelectElementS
    # {
    #     SdifSelectValueT value;
    #     SdifSelectValueT range;
    #     SdifSelectTokens rangetype; /* 0 for not present, sst_range, sst_delta */
    # } SdifSelectElementT, *SdifSelectElementP;
    struct SdifSelectElementS:
        SdifSelectValueT value
        SdifSelectValueT range
        SdifSelectTokens rangetype # /* 0 for not present, sst_range, sst_delta */
    ctypedef SdifSelectElementS SdifSelectElementT
    ctypedef SdifSelectElementS* SdifSelectElementP
        
        # typedef struct SdifSelectIntMaskS
    # {
    #     SdifUInt4   num;            /* number of ints selected */
    #     SdifUInt4   max;            /* max given int, #elems in mask */
    #     int        *mask;           /* selection bit mask */
    #     int         openend;        /* are elems > max included? */
    # } SdifSelectIntMaskT, *SdifSelectIntMaskP;
    struct difSelectIntMaskS:
        SdifUInt4   num       #     /* number of ints selected */
        SdifUInt4   max       #     /* max given int, #elems in mask */
        int        *mask      #     /* selection bit mask */
        int         openend   #     /* are elems > max included? */
    ctypedef difSelectIntMaskS SdifSelectIntMaskT
    ctypedef difSelectIntMaskS* SdifSelectIntMaskP
        
    # /*DOC: 
    #   Holds a selection of what data to access in an SDIF file,
    #   parsed from a simple regular expression.  
    # */
    # typedef struct
    # {
    #     char        *filename,      /* allocated / freed by 
    #                                    SdifInitSelection / SdifFreeSelection */
    #                 *basename;      /* points into filename */
    #     SdifListP   stream, frame, matrix, column, row, time;
    # 
    #     SdifSelectIntMaskT streammask;
    #     SdifSelectIntMaskT rowmask;
    #     SdifSelectIntMaskT colmask;
    # } SdifSelectionT;
    ctypedef struct SdifSelectionT:
        char *filename #     /* allocated / freed by 
        #                                    SdifInitSelection / SdifFreeSelection */
        char *basename #    /* points into filename */
        SdifListP   stream, frame, matrix, column, row, time
        # 
        SdifSelectIntMaskT streammask
        SdifSelectIntMaskT rowmask
        SdifSelectIntMaskT colmask
    # 
    # /* TODO: array of select elements
    #      struct { 
    #         SdifListP list; 
    #         SdifSelectElementT minmax; 
    #         SdifSelectIntMaskP mask;
    #      } elem [eSelNum];
    #      indexed by
    #      enum   { eTime, eStream, eFrame, eMatrix, eColumn, eRow, eSelNum }
    #    to use in all API functions instead of SdifListP.
    # */
    # 
    # 
    # 
    # /* SdifErrMess.h */
    cdef enum SdifErrorTagE:
        eFalse   = 0,
        eUnknown = 0,
        eTrue    = 1,
        eNoError = 1,
        eTypeDataNotSupported,
        eNameLength,
        eEof,       /* 4 */
        eReDefined,
        eUnDefined,
        eSyntax,
        eBadTypesFile,
        eBadType,
        eBadHeader,
        eRecursiveDetect,
        eUnInterpreted,
        eOnlyOneChunkOf,
        eUserDefInFileYet,
        eBadMode,
        eBadStdFile,
        eReadWriteOnSameFile,
        eBadFormatVersion,
        eMtrxUsedYet,
        eMtrxNotInFrame,
        # /* from here on global errors that don't always have an SdifFileT attached */
        eGlobalError,
        eFreeNull = eGlobalError,
        eAllocFail,
        eArrayPosition,
        eFileNotFound,
        eInvalidPreType,
        eAffectationOrder,
        eNoModifErr,
        eNotInDataTypeUnion,
        eNotFound,
        eExistYet,
        eWordCut,
        eTokenLength
    ctypedef SdifErrorTagE SdifErrorTagET
    # 
    # 
    # /*DOC:
    #   Level of Error */
    # typedef enum SdifErrorLevelE
    # {
    #         eFatal,
    #         eError,
    #         eWarning,
    #         eRemark,
    #         eNoLevel,
    #         eNumLevels      /* level count, must always be last */
    # } SdifErrorLevelET;
    cdef enum SdifErrorLevelE:
        eFatal,
        eError,
        eWarning,
        eRemark,
        eNoLevel,   
        eNumLevels     # /* level count, must always be last */
    ctypedef SdifErrorLevelE SdifErrorLevelET
    
    # } SdifErrorLevelET;


    # 
    # 
    # typedef struct SdifErrorS SdifErrorT;
    # struct SdifErrorS
    # {
    #         SdifErrorTagET          Tag;
    #         SdifErrorLevelET        Level;
    #         char*                   UserMess;
    # };
    struct SdifErrorS:
        SdifErrorTagET Tag
        SdifErrorLevelET Level
        char* UserMess
    ctypedef SdifErrorS SdifErrorT
    #

    # 
    # typedef struct SdifErrorLS SdifErrorLT;
    # struct SdifErrorLS
    # {
    #   SdifListT*    ErrorList;
    #   SdifFileT*    SdifF; /* only a link */
    # };
    struct SdifErrorLS:
        SdifListT*    ErrorList
        SdifFileT*    SdifF  #/* only a link */
    ctypedef SdifErrorLS SdifErrorLT
    
    # 
    # 
    # 
    # /*DOC:
    #   Exit function type (See SdifSetExitFunc). */
    # typedef void (*SdifExitFuncT) (void);
    # 
    # /*DOC:
    #  Exception function type (See SdifSetErrorFunc and SdifSetWarningFunc). */
    # typedef void (*SdifExceptionFuncT) (SdifErrorTagET   error_tag, 
    #                                     SdifErrorLevelET error_level, 
    #                                     char *error_message, 
    #                                     SdifFileT *error_file, 
    #                                     SdifErrorT *error_ptr, 
    #                                     char *source_file, int source_line);
    # 
    ctypedef void (*SdifExceptionFuncT) (SdifErrorTagET   error_tag, 
                                     SdifErrorLevelET error_level, 
                                     char *error_message, 
                                     SdifFileT *error_file, 
                                     SdifErrorT *error_ptr, 
                                     char *source_file, int source_line)
    #
    # 
    # /* SdifFileStruct.h */
    # 
    # /*
    # // DATA GROUP:  SDIF File Structure
    # */
    # 
    # /*DOC:
    #   File mode argument for SdifFOpen. */
    # typedef enum SdifFileModeE
    # {
    #   eUnknownFileMode,     /* 0 */
    #   eWriteFile,
    #   eReadFile,
    #   eReadWriteFile,
    #   ePredefinedTypes,     /* 4 */
    # 
    #   eModeMask = 7,        /* get rid of flags */
    # 
    #   /* from here on we have flags that can be or'ed with the previous modes */
    #   eParseSelection = 8
    # } SdifFileModeET ;
    # 
    enum SdifFileModeE:
        eUnknownFileMode,
        eWriteFile,
        eReadFile,
        eReadWriteFile,
        ePredefinedTypes,     #/* 4 */
         
        eModeMask = 7,        /* get rid of flags */
         
        #   /* from here on we have flags that can be or'ed with the previous modes */
        eParseSelection = 8


    # 
    # enum SdifPassE
    # {
    #   eNotPass,
    #   eReadPass,
    #   eWritePass
    # };
    enum SdifPassE:
        eNotPass,
        eReadPass,
        eWritePass
    
    # 
    # 
    # /*
    # // DATA GROUP:          SDIF File Structure
    # */
    # 
    # #define MaxUserData     10
    # /*DOC:



    #   THE SDIF File Structure! */

    # struct SdifFileS
    # {
    #   char               *Name;             /* Name of the file, can be "stdin, stdout, stderr */
    #   SdifFileModeET     Mode;              /* eWriteFile or eReadFile or ePredefinedTypes */
    #   int                isSeekable;        /* file is not pipe i/o */
    # 
    #   SdifUInt4          FormatVersion;     /* version of the SDIF format itself */
    #   SdifUInt4          TypesVersion;      /* version of the description type collection */
    # 
    #   SdifNameValuesLT   *NameValues;       /* DataBase of Names Values */
    #   SdifHashTableT     *MatrixTypesTable; /* DataBase of Matrix Types */
    #   SdifHashTableT     *FrameTypesTable;  /* DataBase of Frame Types */
    # /*  SdifHashTableT     *StreamIDsTable;    DataBase of Stream IDs */
    #   SdifStreamIDTableT *StreamIDsTable;   /* DataBase of Stream IDs */
    #   SdifTimePositionLT *TimePositions;    /* List of (Time, Position in file) */
    #   SdifSelectionT     *Selection;        /* default selection parsed from Name */
    # 
    #   FILE *Stream;                         /* Stream to read or to write */
    # 
    #   SdifSignature      CurrSignature;
    #   SdifFrameHeaderT   *CurrFramH;        /* Current Frame Header can be NULL */
    #   SdifMatrixHeaderT  *CurrMtrxH;        /* Current Matrix Header can be NULL */
    # 
    #   SdifFrameTypeT     *CurrFramT;
    #   SdifMatrixTypeT    *CurrMtrxT;
    #   SdifFloat8         PrevTime;
    #   SdifSignatureTabT  *MtrxUsed;
    # 
    #   SdifOneRowT        *CurrOneRow;
    #   /* Current OneRow allocated memory in function
    #    * of _SdifGranule, use SdifReInitOneRow(SdifOneRowT *OneRow, SdifDataTypeET DataType, SdifUInt4 NbData)
    #    * to assure NbData (=NbColumns) objects memory allocated
    #    */
    # 
    #   /* data pointer used by SdifFReadMatrixData, never uses the Header field */
    #   SdifMatrixDataT    *CurrMtrxData;
    # 
    #   size_t  FileSize;
    #   size_t  ChunkSize;
    # 
    #   SdiffPosT  CurrFramPos;
    #   SdiffPosT  StartChunkPos;
    #   SdiffPosT  Pos;
    #   
    #   SdifUInt2  TypeDefPass;
    #   SdifUInt2  StreamIDPass;
    # 
    #   char *TextStreamName;                 /* Name of the text file corresponding to the sdif file */
    #   FILE *TextStream;                     /* Stream text */
    # 
    #   SdifUInt4     ErrorCount [eNumLevels];/* Error count per level of severity */
    #   SdifErrorLT  *Errors;                 /* List of errors or warnings */
    # 
    #   int           NbUserData;             /* todo: hash table */
    #   void          *UserData [MaxUserData];
    # };      /* end struct SdifFileS */


    struct SdifFileS:
        char               *Name;             /* Name of the file, can be "stdin, stdout, stderr */
        SdifFileModeET     Mode;              /* eWriteFile or eReadFile or ePredefinedTypes */
        int                isSeekable;        /* file is not pipe i/o */
        SdifUInt4          FormatVersion;     /* version of the SDIF format itself */
        SdifUInt4          TypesVersion;      /* version of the description type collection */
        SdifNameValuesLT   *NameValues;       /* DataBase of Names Values */
        SdifHashTableT     *MatrixTypesTable; /* DataBase of Matrix Types */
        SdifHashTableT     *FrameTypesTable;  /* DataBase of Frame Types */
        # /*  SdifHashTableT     *StreamIDsTable;    DataBase of Stream IDs */
        SdifStreamIDTableT *StreamIDsTable    #/* DataBase of Stream IDs */
        SdifTimePositionLT *TimePositions     #/* List of (Time, Position in file) */
        SdifSelectionT     *Selection         #/* default selection parsed from Name */
        FILE *Stream;                         #/* Stream to read or to write */
        SdifSignature      CurrSignature
        SdifFrameHeaderT   *CurrFramH         #/* Current Frame Header can be NULL */
        SdifMatrixHeaderT  *CurrMtrxH         #/* Current Matrix Header can be NULL */
        SdifFrameTypeT     *CurrFramT
        SdifMatrixTypeT    *CurrMtrxT
        SdifFloat8         PrevTime
        SdifSignatureTabT  *MtrxUsed
        SdifOneRowT        *CurrOneRow
        #   /* Current OneRow allocated memory in function
        #    * of _SdifGranule, use SdifReInitOneRow(SdifOneRowT *OneRow, SdifDataTypeET DataType, SdifUInt4 NbData)
        #    * to assure NbData (=NbColumns) objects memory allocated
        #    */
        # 
        #   /* data pointer used by SdifFReadMatrixData, never uses the Header field */
        SdifMatrixDataT    *CurrMtrxData
        size_t  FileSize
        size_t  ChunkSize
        SdiffPosT  CurrFramPos
        SdiffPosT  StartChunkPos
        SdiffPosT  Pos
        SdifUInt2  TypeDefPass
        SdifUInt2  StreamIDPass
        char *TextStreamName                  #/* Name of the text file corresponding to the sdif file */
        FILE *TextStream                      #/* Stream text */
        SdifUInt4     ErrorCount [eNumLevels] #/* Error count per level of severity */
        SdifErrorLT  *Errors                  #/* List of errors or warnings */
        int           NbUserData              #/* todo: hash table */
        void          *UserData [MaxUserData]

    # };      /* end struct SdifFileS */


    # 
    # 
    # 
    # 
    # 
    # 
    # 
    # /* SdifString.h */
    # 
    # typedef struct SdifStringS SdifStringT;
    # struct SdifStringS
    # {
    #   char   *str; 
    #   size_t TotalSize; /* Memory size allocated for str */
    #   size_t SizeW; /* Memory size actually used */
    #   int    NbCharRead; /* Number of char read */
    # };
    struct SdifStringS:
        char   *str; 
        size_t TotalSize; #/* Memory size allocated for str */
        size_t SizeW; #/* Memory size actually used */
        int    NbCharRead; #/* Number of char read */
    # 
    # 
    # /*DOC: 
    #   Test if file is an SDIF file.
    # 
    #   [] Returns:   0 if not an SDIF file (the first 4 chars are not "SDIF"),
    #                 or file can not be opened, else 1.  
    # 
    #   Warning: This function doesn't work with stdio. */
    # SDIF_API int SdifCheckFileFormat (const_char_ptr name);
    SDIF_API int SdifCheckFileFormat (const_char_ptr name)
    # 
    # 
    # /*DOC: 
    #   Test if file contains frames of certain types.
    # 
    #   [in]  name    Filename + selection
    #         frames  Table of frame signatures to look for
    #   []    return  The first signature from frames found, or eEmptySignature if 
    #                 no frames could be found (or if file is not SDIF).
    # 
    #   Warning: This function doesn't work with stdio. */
    # SDIF_API SdifSignature SdifCheckFileFramesTab (const char              *name, 
    #                                                const SdifSignatureTabT *frames);
    ctypedef SdifSignatureTabT* const_SdifSignatureTabT_ptr "const SdifSignatureTabT*"
    SDIF_API SdifSignature SdifCheckFileFramesTab (const_char_ptr name, const_SdifSignatureTabT_ptr frames)

    # 
    # /*DOC: 
    #   Test if file contains frames of certain types.
    # 
    #   [in]  name    Filename + selection
    #         frames  Array of frame signatures to look for, terminated with 
    #                 eEmptySignature.
    #   []    return  The index in frames of the first signature found, or -1
    #                 if no frames could be found (or if file is not SDIF).
    # 
    #   Warning: This function doesn't work with stdio. */
    # SDIF_API int  SdifCheckFileFramesIndex (const char              *name, 
    #                                         const SdifSignature     *frames);
    ctypedef SdifSignature* const_SdifSignature_ptr "const SdifSignature*"
    SDIF_API int SdifCheckFileFramesIndex (const_char_ptr name, const_SdifSignature_ptr frames)
    #

    # /*DOC: 
    #   Test if file contains frames of certain types.
    # 
    #   [in]  in      open SDIF file
    #         frames  Table of frame signatures to look for
    #   [out] index   If the int pointer index is not NULL, it will receive
    #                 the index in frames of the first signature found, or -1
    #                 if no frames could be found (or if file is not SDIF).
    #   []    return  The first signature from frames found, or eEmptySignature if 
    #                 no frames could be found (or if file is not SDIF).
    # 
    #   Warning: This function doesn't work with stdio. */
    # SDIF_API SdifSignature SdifCheckNextFrame (SdifFileT               *in, 
    #                                            const SdifSignatureTabT *frames,
    #                                            int                     *index);
    # 
    # /*DOC: 
    #   TODO: Test if file is an SDIF file (only when opening for read or
    #   append) and open it.
    # 
    #   [Return] NULL if not an SDIF file (the first 4 chars are not "SDIF"),
    #   or file can not be opened.  */
    # SDIF_API SdifFileT* SdifFTryOpen (const_char_ptr Name, SdifFileModeET Mode);  
    SDIF_API SdifFileT* SdifFTryOpen (const_char_ptr Name, SdifFileModeET Mode)
    # 
    # 
    # /*DOC: 
    #   Converti un fichier texte pseudo-SDIF de nom TextStreamName en un
    #   fichier SDIF binaire de non SdifF->Name. Le fichier doit avoir été
    #   ouvert en écriture (eWriteFile).  */
    # SDIF_API size_t SdifToText (SdifFileT *SdifF, char *TextStreamName);
    SDIF_API size_t SdifToText (SdifFileT *SdifF, char *TextStreamName)

    # 
    # 
    # /*#include "SdifFile.h"
    #  */
    # 
    # 
    # /*DOC:
    #   Switch output of error messages on stderr by _SdifFError on. 
    # */
    # SDIF_API void   SdifEnableErrorOutput  (void);
    # 
    # /*DOC:
    #   Switch output of error messages on stderr by _SdifFError off. 
    # */
    # SDIF_API void   SdifDisableErrorOutput (void);
    # 
    # 
    # /* global variables to control error output */
    # extern SDIF_API int              gSdifErrorOutputEnabled;
    # extern SDIF_API char            *SdifErrorFile;
    # extern SDIF_API int              SdifErrorLine;
    # extern SDIF_API FILE            *SdifStdErr;
    int              gSdifErrorOutputEnabled
    char            *SdifErrorFile
    int              SdifErrorLine
    FILE            *SdifStdErr
    #

    # 
    # 
    # /*DOC: 
    #   Lit 4 bytes, les considère comme une signature qui est placée dans
    #   SdifF->CurrSignature, incrémente NbCharRead du nombre de bytes lus
    #   et renvoie le dernier caractère lu convert en int (-1 si erreur).  */
    # SDIF_API int    SdifFGetSignature       (SdifFileT *SdifF, size_t *NbCharRead);
    SDIF_API int SdifFGetSignature (SdifFileT *SdifF, size_t *NbCharRead)
    # 
    # 
    # /*DOC: 
    #   Lit l'entête du fichier, c'est à dire 'SDIF' puis 4 bytes.  affiche
    #   un message en cas de non reconnaissance du format.  */
    # SDIF_API size_t SdifFReadGeneralHeader    (SdifFileT *SdifF);
        SDIF_API size_t SdifFReadGeneralHeader (SdifFileT *SdifF)
    # 
    # SDIF_API size_t SdifFReadAllASCIIChunks   (SdifFileT *SdifF);
    SDIF_API size_t SdifFReadAllASCIIChunks   (SdifFileT *SdifF)
    # 
    # /*DOC: 
    #   Cette fonction lit une entête de matrice <strong>signature
    #   incluse</strong>.  Elle vérifie le type de matrice, le champ
    #   DataType. Toute les données se trouvent stockées dans
    #   SdifF->CurrMtrxH. La plupart de ses champs sont directement
    #   accessible par les fonctions indépendantes du mode d'ouverture du
    #   fichier.  <strong>Elle effectue une mise à jour de l'allocation
    #   mémoire de SdifF->CurrOneRow en fonction des paramètres de l'entête
    #   de matrice.</strong> Ainsi, on est normalement près pour lire chaque
    #   ligne de la matrice courrante.  
    # 
    #   @return       number of bytes read or 0 if error 
    # */
    # SDIF_API size_t SdifFReadMatrixHeader     (SdifFileT *SdifF);
    SDIF_API size_t SdifFReadMatrixHeader     (SdifFileT *SdifF)
    # 
    # /*DOC: 
    #   Cette fonction permet de lire 1 ligne de matrice. Les données lues
    #   sont stockées dans SdifF->CurrOneRow (jusqu'à une prochaine lecture
    #   d'entête de matrice qui réinitialise ses paramètres).  */
    # SDIF_API size_t SdifFReadOneRow           (SdifFileT *SdifF);
    SDIF_API size_t SdifFReadOneRow           (SdifFileT *SdifF)
    # 
    # /*DOC:
    #   skip one matrix row, when reading row by row with SdifFReadOneRow */
    # SDIF_API size_t SdifFSkipOneRow(SdifFileT *SdifF);
    SDIF_API size_t SdifFSkipOneRow(SdifFileT *SdifF)
    # 
    # 
    # /*DOC: 
    #   Cette fonction lit l'entête d'un frame à partir de la taille et
    #   jusqu'au temps. Donc <strong>elle ne lit pas la signature</strong>
    #   mais donne à SdifF->CurrFramH->Signature la valeur de
    #   SdifF->CurrSignature.  La lecture doit se faire avant, avec
    #   SdifFGetSignature.  */
    # SDIF_API size_t SdifFReadFrameHeader      (SdifFileT *SdifF);
    SDIF_API size_t SdifFReadFrameHeader      (SdifFileT *SdifF)
    # 
    # /*DOC: 
    #   Cette fonction permet de passer une matrice toute entière entête
    #   incluse. Elle est utile lorsque qu'un frame contient plus de
    #   matrices que le programme lecteur n'en connaît. Il peut ainsi les
    #   passer pour retomber sur un autre frame.  */
    # SDIF_API size_t SdifFSkipMatrix          (SdifFileT *SdifF);
    SDIF_API size_t SdifFSkipMatrix          (SdifFileT *SdifF)
    # 
    # /*DOC: 
    #   Cette fonction permet de passer une matrice mais après la lecture de
    #   l'entête. On s'en sert lorsque le type de matrice est mauvais,
    #   inconnu, non interprétable par le programme lecteur.
    # 
    #   Note:  The matrix padding is skipped also. */
    # SDIF_API size_t SdifFSkipMatrixData       (SdifFileT *SdifF);
    SDIF_API size_t SdifFSkipMatrixData       (SdifFileT *SdifF)
    # 
    # /*DOC: 
    #   Cette fonction à le même sens que SdifSkipMatrixData mais pour les
    #   frames. Il faut donc pour l'utiliser avoir au préalable lu la
    #   signature et l'entête.  */
    # SDIF_API size_t SdifFSkipFrameData        (SdifFileT *SdifF);
    SDIF_API size_t SdifFSkipFrameData        (SdifFileT *SdifF)
    # 
    # /*DOC: 
    #   Cette fonction permet de lire le Padding en fin de matrice.
    #   l'utilisation classique de cette fonctin est:<br> 
    #   <code> SizeR =  SdifFReadPadding(SdifF, SdifFPaddingCalculate(SdifF->Stream, SizeR));</code><br> 
    #   où SizeR est la taille en bytes lue depuis le
    #   début de la matrice, c'est à dire NbRow*NbCol*DataWith. En réalité,
    #   pour que SdifFPaddingCalculate fonctionne, il est seulement
    #   nécessaire que SizeR soit le nombre de bytes qui s'épare la position
    #   actuelle dans le fichier et un byte, repère d'allignement sur 64
    #   bits.  */
    # SDIF_API size_t SdifFReadPadding          (SdifFileT *SdifF, size_t Padding);
    SDIF_API size_t SdifFReadPadding          (SdifFileT *SdifF, size_t Padding)
    # 
    # 
    # /* skip given number of bytes, either by seeking or by reading bytes */
    # SDIF_API size_t SdifFSkip (SdifFileT *SdifF, size_t bytes);
    SDIF_API size_t SdifFSkip (SdifFileT *SdifF, size_t bytes)
    # 
    # 
    # /*DOC:
    #   Read and throw away <i>num</i> bytes from the file. */
    # SDIF_API size_t SdifFReadAndIgnore (SdifFileT *SdifF, size_t bytes);
    SDIF_API size_t SdifFReadAndIgnore (SdifFileT *SdifF, size_t bytes)
    # 
    # 
    # /*DOC: 
    #   écrit sur le fichier 'SDIF' puis 4 bytes chunk size.  */
    # SDIF_API size_t  SdifFWriteGeneralHeader   (SdifFileT *SdifF);
    SDIF_API size_t  SdifFWriteGeneralHeader   (SdifFileT *SdifF)
    # 
    # /*DOC: 
    #   écrit tous les chunks ASCII. C'est à dire: les tables de names
    #   values, les types créés ou complétés, et les Stream ID. Il faut donc
    #   au préalable avoir rempli complétement les tables avant de la
    #   lancer. Cette fonction de peut donc pas être executer une 2nd fois
    #   durant une écriture.  */
    # SDIF_API size_t  SdifFWriteAllASCIIChunks  (SdifFileT *SdifF);
    DIF_API size_t  SdifFWriteAllASCIIChunks  (SdifFileT *SdifF)
    # 
    # 
    # /*
    # //FUNCTION GROUP:       Writing Matrices
    # */
    # 
    # /*DOC: 
    #   Après avoir donner une valeur à chaque champ de SdifF->CurrMtrxH
    #   gràce à la fonction SdifFSetCurrMatrixHeader, SdifFWriteMatrixHeader
    #   écrit toute l'entête de la matrice.  Cette fonction réalise aussi
    #   une mise à jour de SdifF->CurrOneRow, tant au niveau de l'allocation
    #   mémoire que du type de données.  */
    # SDIF_API size_t  SdifFWriteMatrixHeader    (SdifFileT *SdifF);
    SDIF_API size_t  SdifFWriteMatrixHeader    (SdifFileT *SdifF)
    # 
    # /*DOC: 
    #   Après avoir donner les valeurs à chaque case de SdifF->CurrOneRow à
    #   l'aide de SdifFSetCurrOneRow ou de SdifFSetCurrOneRowCol (suivant
    #   que l'on possède déjà un tableau flottant ou respectivement une
    #   méthode pour retrouver une valeur de colonne), SdifFWriteOneRow
    #   écrit 1 ligne de matrice suivant les paramètres de SdifF->CurrMtrxH.  */
    # SDIF_API size_t  SdifFWriteOneRow          (SdifFileT *SdifF);
    SDIF_API size_t  SdifFWriteOneRow          (SdifFileT *SdifF)
    # 
    # /*DOC: 
    #   Write whole matrix data, (after having set the matrix header with 
    #   SdifFSetCurrMatrixHeader (file, matrixsig, datatype, nrow, ncol).
    #   Data points to nbrow * nbcol * SdifSizeofDataType (datatype) bytes in 
    #   row-major order.  Padding still has to be written.  */
    # SDIF_API size_t SdifFWriteMatrixData (SdifFileT *SdifF, void *Data);
    SDIF_API size_t SdifFWriteMatrixData (SdifFileT *SdifF, void *Data)
    # 
    # /*DOC:
    #   Write whole matrix: header, data, and padding.
    #   Data points to NbRow * NbCol * SdifSizeofDataType (DataType) bytes in
    #   row-major order. */
    SDIF_API size_t SdifFWriteMatrix (SdifFileT     *SdifF,
                                   SdifSignature  Signature,
                                   SdifDataTypeET DataType,
                                   SdifUInt4      NbRow,
                                   SdifUInt4      NbCol,
                                   void          *Data)
 
    # /*DOC:
    #   Write a matrix with datatype text (header, data, and padding).
    #   Data points to Length bytes(!) of UTF-8 encoded text.  Length
    #   includes the terminating '\0' character!!!  That is, to write a
    #   C-String, use SdifFWriteTextMatrix (f, sig, strlen (str) + 1, str);
    #   to include it. */
    # SDIF_API size_t SdifFWriteTextMatrix (SdifFileT     *SdifF,
    #                              SdifSignature  Signature,
    #                              SdifUInt4      Length,
    #                              char          *Data);
    SDIF_API size_t SdifFWriteTextMatrix (SdifFileT *SdifF,
                                          SdifSignature Signature,
                                          SdifUInt4 Length,
                                          char *Data)

    # 
    # /*DOC: 
    #   TBI: Convert ASCII C-String to UTF-8 encoded string, returning
    #   length (including terminating null character). */
    # SDIF_API size_t SdifAsciiToUTF8 (char *ascii_in, char *utf8_out);
    # 
    # /*DOC: 
    #   Cette fonction permet en fin d'écriture de matrice d'ajouter le
    #   Padding nécessaire. Il faut cependant avoir la taille de ce
    #   Padding. On utilise SdifFPaddingCalculate(SdifF->Stream,
    #   SizeSinceAlignement) où SizeSinceAllignement est un
    #   <code>size_t</code> désignant le nombre de bytes qui sépare la
    #   position actuelle d'écriture avec une position connue où le fichier
    #   est aligné sur 64 bits (en général, c'est la taille de la matrice en
    #   cours d'écriture: NbRow*NbCol*DatWitdh).  */
    # SDIF_API size_t  SdifFWritePadding         (SdifFileT *SdifF, size_t Padding);
    SDIF_API size_t  SdifFWritePadding         (SdifFileT *SdifF, size_t Padding)
    # 
    # 
    # /*
    # //FUNCTION GROUP:       Writing Frames
    # */
    # 
    # /*DOC: 
    #   Après avoir donner une valueur à chaque champ de SdifF->CurrFramH
    #   gràce à la fonction SdifFSetCurrFrameHeader, SdifFWriteFrameHeader
    #   écrit toute l'entête de frame.  Lorsque la taille est inconnue au
    #   moment de l'écriture, donner la valeur _SdifUnknownSize. Ensuite,
    #   compter le nombre de bytes écrit dans le frame et réaliser un
    #   SdifUpdateChunkSize avec la taille calculée.  */
    # SDIF_API size_t  SdifFWriteFrameHeader     (SdifFileT *SdifF);
    SDIF_API size_t  SdifFWriteFrameHeader     (SdifFileT *SdifF)
    # 
    # /*DOC: 
    #   Execute un retour fichier de ChunkSize bytes et l'écrit, donc on
    #   écrase la taille du chunk ou du frame.  Dans le cas où le fichier
    #   est stderr ou stdout, l'action n'est pas réalisée.  */
    # SDIF_API void    SdifUpdateChunkSize       (SdifFileT *SdifF, size_t ChunkSize);
    SDIF_API void    SdifUpdateChunkSize       (SdifFileT *SdifF, size_t ChunkSize)
    # 
    # /*DOC: 
    #   Rewrite given frame size and number of matrices in frame header.
    #   Return -1 on error or if file is not seekable (stdout or stderr). */
    # SDIF_API int     SdifUpdateFrameHeader     (SdifFileT *SdifF, size_t ChunkSize, 
    #                                    SdifInt4 NumMatrix);

    SDIF_API int SdifUpdateFrameHeader (SdifFileT *SdifF, 
                                        size_t ChunkSize, 
                                        SdifInt4 NumMatrix)
    ## 
    # /*DOC:
    #   Write a whole frame containing one matrix: 
    #   frame header, matrix header, matrix data, and padding.
    #   Data points to NbRow * NbCol * SdifSizeofDataType (DataType) bytes in
    #   row-major order. 
    # 
    #   This function has the big advantage that the frame size is known in
    #   advance, so there's no need to rewind and update after the matrix
    #   has been written.  */
    # SDIF_API size_t SdifFWriteFrameAndOneMatrix (SdifFileT     *SdifF,
    #                                              SdifSignature  FrameSignature,
    #                                              SdifUInt4      NumID,
    #                                              SdifFloat8     Time,
    #                                              SdifSignature  MatrixSignature,
    #                                              SdifDataTypeET DataType,
    #                                              SdifUInt4      NbRow,
    #                                              SdifUInt4      NbCol,
    #                                              void          *Data);
    # 
    SDIF_API size_t SdifFWriteFrameAndOneMatrix (SdifFileT     *SdifF,
                                              SdifSignature  FrameSignature,
                                              SdifUInt4      NumID,
                                              SdifFloat8     Time,
                                              SdifSignature  MatrixSignature,
                                              SdifDataTypeET DataType,
                                              SdifUInt4      NbRow,
                                              SdifUInt4      NbCol,
                                              void          *Data)
    #
    # 
    # /*DOC:
    #   Return (constant) size of frame header after signature and size field. 
    #   Use this to calculate the Size argument for SdifFSetCurrFrameHeader. */
    # SDIF_API size_t SdifSizeOfFrameHeader (void);
    SDIF_API size_t SdifSizeOfFrameHeader (void);
    # 
    # /*DOC:
    #   Return size of matrix (header, data, padding).
    #   Use this to calculate the Size argument for SdifFSetCurrFrameHeader. */
    # SDIF_API size_t SdifSizeOfMatrix (SdifDataTypeET DataType,
    #                                   SdifUInt4      NbRow,
    #                                   SdifUInt4      NbCol);
    SDIF_API size_t SdifSizeOfMatrix (SdifDataTypeET DataType,
                                   SdifUInt4      NbRow,
                                   SdifUInt4      NbCol)
    #

    # 
    # /*DOC:
    #   Write a text matrix using a string.
    #   Return number of bytes written.
    # */
    # SDIF_API size_t SdifFWriteTextFrame(SdifFileT     *SdifF,
    #                                     SdifSignature FrameSignature,
    #                                     SdifUInt4     NumID,
    #                                     SdifFloat8    Time,
    #                                     SdifSignature MatrixSignature,
    #                                     char          *str,
    #                                     size_t        length);
    # 
    SDIF_API size_t SdifFWriteTextFrame(SdifFileT     *SdifF,
                                     SdifSignature FrameSignature,
                                     SdifUInt4     NumID,
                                     SdifFloat8    Time,
                                     SdifSignature MatrixSignature,
                                     char          *str,
                                     size_t        length)

    #
    # /*DOC:
    #   Write a text matrix using a SdifString.
    #   Return number of bytes written.
    # */
    # SDIF_API size_t SdifFWriteTextFrameSdifString(SdifFileT     *SdifF,
    #                                               SdifSignature FrameSignature,
    #                                               SdifUInt4     NumID,
    #                                               SdifFloat8    Time,
    #                                               SdifSignature MatrixSignature,
    #                                               SdifStringT   *SdifString);
    # 
    SDIF_API size_t SdifFWriteTextFrameSdifString(SdifFileT     *SdifF,
                                               SdifSignature FrameSignature,
                                               SdifUInt4     NumID,
                                               SdifFloat8    Time,
                                               SdifSignature MatrixSignature,
                                               SdifStringT   *SdifString)



    # 
    # /*
    # // FUNCTION GROUP:      Opening and Closing of Files
    # */
    # 
    # /*DOC:
    #  */
    # SDIF_API SdifFileT* SdifFOpen                   (const_char_ptr Name, SdifFileModeET Mode);
    SDIF_API SdifFileT* SdifFOpen (const_char_ptr Name, SdifFileModeET Mode)
    # 
    # SDIF_API SdifFileT*         SdifFOpenText                (SdifFileT *SdifF, const char* Name, SdifFileModeET Mode);
    SDIF_API SdifFileT* SdifFOpenText (SdifFileT *SdifF, const_char_ptr Name, SdifFileModeET Mode)
    
    # 
    # /*DOC:
    #  */
    # SDIF_API void      SdifFClose                   (SdifFileT *SdifF);
    SDIF_API void SdifFClose (SdifFileT *SdifF)
    # 
    # SDIF_API SdifFrameHeaderT*  SdifFCreateCurrFramH         (SdifFileT *SdifF, SdifSignature Signature);
    # SDIF_API SdifMatrixHeaderT* SdifFCreateCurrMtrxH         (SdifFileT *SdifF);
    # SDIF_API FILE*              SdifFGetFILE_SwitchVerbose   (SdifFileT *SdifF, int Verbose);
    # SDIF_API void               SdifTakeCodedPredefinedTypes (SdifFileT *SdifF);
    # SDIF_API void               SdifFLoadPredefinedTypes     (SdifFileT *SdifF, const_char_ptr TypesFileName);
    # 
    SDIF_API SdifFrameHeaderT*  SdifFCreateCurrFramH         (SdifFileT *SdifF, SdifSignature Signature);
    SDIF_API SdifMatrixHeaderT* SdifFCreateCurrMtrxH         (SdifFileT *SdifF);
    SDIF_API FILE*              SdifFGetFILE_SwitchVerbose   (SdifFileT *SdifF, int Verbose);
    SDIF_API void               SdifTakeCodedPredefinedTypes (SdifFileT *SdifF);
    SDIF_API void               SdifFLoadPredefinedTypes     (SdifFileT *SdifF, const_char_ptr TypesFileName);
    #
    # extern SDIF_API int        gSdifInitialised;
    # extern SDIF_API SdifFileT *gSdifPredefinedTypes;
    # 
    int        gSdifInitialised
    SdifFileT *gSdifPredefinedTypes
    # 
    # 
    # /*
    # // FUNCTION GROUP:      Init/Deinit of the Library
    # */
    # 
    # /*DOC: 
    #   Initialise the SDIF library, providing a name for an optional additional
    #   file with type definitions or "".
    #   <b>This function has to be called once and only once per process 
    #   before any other call to the SDIF library.</b> */
    # SDIF_API void SdifGenInit (const_char_ptr PredefinedTypesFile); 
    SDIF_API void SdifGenInit (const_char_ptr PredefinedTypesFile)
    # 
    # /*DOC:
    #   Initialise the SDIF library if it has not been initialised before.
    #   This function has to be called at least once, but can be called as
    #   many times as desired.  Especially useful for dynamic libraries.
    # 
    #   [in] PredefinedTypesFile:
    #         name for an optional additional file with type definitions or "". */
    # SDIF_API void SdifGenInitCond (const_char_ptr PredefinedTypesFile);
    SDIF_API void SdifGenInitCond (const_char_ptr PredefinedTypesFile)
    # 
    # /*DOC:
    #   Deinitialise the SDIF library */
    # SDIF_API void SdifGenKill (void); 
    SDIF_API void SdifGenKill (void)
    # 
    # /*DOC:
    #   Set function that will be called after a grave error has occurred.  
    #   Default is exit(). */
    # SDIF_API void SdifSetExitFunc (SdifExitFuncT func);
    SDIF_API void SdifSetExitFunc (SdifExitFuncT func)
    # 
    # /*DOC:
    #   Set function that will be called after an error has occured.
    #   make an exception. */
    # SDIF_API void SdifSetErrorFunc (SdifExceptionFuncT func);
    SDIF_API void SdifSetErrorFunc (SdifExceptionFuncT func)
    # 
    # /*DOC:
    #   Set function that will be called after a warning has occured.
    #   make an exception. */
    # SDIF_API void SdifSetWarningFunc (SdifExceptionFuncT func);
    SDIF_API void SdifSetWarningFunc (SdifExceptionFuncT func)
    # 
    # /*DOC:
    #   Print version information to standard error. */
    # SDIF_API void SdifPrintVersion(void);
    SDIF_API void SdifPrintVersion(void)
    # 
    # 
    # /*
    # // FUNCTION GROUP:      Current Header Access Functions
    # */
    # 
    # /*DOC: 
    #   Permet de donner des valeurs à chaque champ de l'entête de frame
    #   temporaire de SdifF.<p> 
    # 
    #   Exemple:
    #   <code>SdifSetCurrFrameHeader(SdifF, '1FOB', _SdifUnknownSize, 3, streamid, 1.0);</code> */
    # SDIF_API SdifFrameHeaderT* SdifFSetCurrFrameHeader (SdifFileT *SdifF, 
    #                                                     SdifSignature Signature, 
    #                                                     SdifUInt4 Size,
    #                                                     SdifUInt4 NbMatrix, 
    #                                                     SdifUInt4 NumID, 
    #                                                     SdifFloat8 Time);
    # 
    SDIF_API SdifFrameHeaderT* SdifFSetCurrFrameHeader (SdifFileT *SdifF, 
                                                     SdifSignature Signature, 
                                                     SdifUInt4 Size,
                                                     SdifUInt4 NbMatrix, 
                                                     SdifUInt4 NumID, 
                                                     SdifFloat8 Time)

    # /*DOC: 
    #   Permet de donner des valeurs à chaque champ de l'entête de matice
    #   temporaire de SdifF.<p>
    # 
    #   Exemple:
    #   <code>SdifSetCurrMatrixHeader(SdifF, '1FOF', eFloat4, NbFofs, 7);</code> */
    # SDIF_API SdifMatrixHeaderT* SdifFSetCurrMatrixHeader (SdifFileT *SdifF, 
    #                                                       SdifSignature Signature,
    #                                                       SdifDataTypeET DataType, 
    #                                                       SdifUInt4 NbRow, 
    #                                                       SdifUInt4 NbCol);
    SDIF_API SdifMatrixHeaderT* SdifFSetCurrMatrixHeader (SdifFileT *SdifF, 
                                                       SdifSignature Signature,
                                                       SdifDataTypeET DataType, 
                                                       SdifUInt4 NbRow, 
                                                       SdifUInt4 NbCol)

    # 
    # 
    # /*DOC: 
    #   Recopie la mémoire pointée par Values en fonction de l'entête de
    #   matrice courante.<p> 
    # 
    #   Exemple:<br>
    # <pre>
    #   #define NbCols = 10;<br>
    # 
    #   float t[NbCols] = { 1., 2., 3., 4., 5., 6., 7., 8., 9., 0.};<br>
    # 
    #   SdifFSetCurrMatrixHeader(SdifF, 'mtrx', eFloat4, 1, NbCols);<br>
    #   SdifFSetCurrOneRow      (SdifF, (void*) t);<br>
    # </pre>
    # 
    #   On connait la taille de la mémoire à recopier par le type de donnée
    #   (ici: eFloat4) et le nombre de colonnes (ici: NbCols). Il faut que
    #   le type de donnée de la matrice courante corresponde avec la taille
    #   d'un élément de t. Si t est composé de float sur 4 bytes, alors on
    #   doit avoir eFloat4. Si t est composé de double float sur 8 bytes,
    #   alors c'est eFloat8.<br>
    # 
    #   En général, les données d'un programme ne se présente pas sous cette
    #   forme et il faut réaliser une transposition lors des transfert de
    #   Sdif à un programme. Le programme Diphone Ircam a un bon exemple de
    #   lecture avec transposition automatique, généralisée pour tout type
    #   de matrice. */
    # SDIF_API SdifOneRowT*  SdifFSetCurrOneRow       (SdifFileT *SdifF, void *Values);
    SDIF_API SdifOneRowT* SdifFSetCurrOneRow (SdifFileT *SdifF, void *Values)
    # 
    # 
    # /*DOC: 
    #   Permet de donner la valeur Value dans la ligbe de matrice temporaire
    #   de SdifF à la colonne numCol (0<numCol<=SdifF->CurrMtrxH->NbCol).  */
    # SDIF_API SdifOneRowT* SdifFSetCurrOneRowCol (SdifFileT *SdifF, SdifUInt4 numCol, SdifFloat8 Value);
    SDIF_API SdifOneRowT* SdifFSetCurrOneRowCol (SdifFileT *SdifF, SdifUInt4 numCol, SdifFloat8 Value)
    # 
    # 
    # /*DOC: 
    #   Recupère la valeur stockée à la colonne numCol de la ligne
    #   temporaire.  C'est un SdifFloat8 donc un double!!  */ 
    # SDIF_API SdifFloat8 SdifFCurrOneRowCol (SdifFileT *SdifF, SdifUInt4 numCol);
    SDIF_API SdifFloat8 SdifFCurrOneRowCol (SdifFileT *SdifF, SdifUInt4 numCol)
    # 
    # 
    # /*DOC: 
    #   Idem que la fonction précédente mais en utilisant le type de la
    #   matrice et le nom de la colonne.  */
    # SDIF_API SdifFloat8    SdifFCurrOneRowColName   (SdifFileT *SdifF, 
    #                                         SdifMatrixTypeT *MatrixType, 
    #                                         const_char_ptr NameCD);
    SDIF_API SdifFloat8 SdifFCurrOneRowColName (SdifFileT *SdifF, 
                                         SdifMatrixTypeT *MatrixType, 
                                         const_char_ptr NameCD)

    # 
    # 
    # /*DOC: 
    #   Renvoie la signature temporaire de Chunk ou de Frame.  */
    # SDIF_API SdifSignature SdifFCurrSignature       (SdifFileT *SdifF);
    SDIF_API SdifSignature SdifFCurrSignature (SdifFileT *SdifF)
    # 
    # 
    # /*DOC: 
    #   Met à 0 tous les bits de la signature temporaire.  */
    SDIF_API SdifSignature SdifFCleanCurrSignature  (SdifFileT *SdifF)
    # 
    # /*DOC: 
    #   Renvoie la signature temporaire du dernier Frame lu ou du prochain à
    #   écrire.  */
    SDIF_API SdifSignature SdifFCurrFrameSignature  (SdifFileT *SdifF)
    # 
    # /*DOC: 
    #   Renvoie la signature temporaire de la dernier matrice lue ou de la
    #   prochaine à écrire.  */
    SDIF_API SdifSignature SdifFCurrMatrixSignature (SdifFileT *SdifF)
    # 
    # /*DOC: 
    #   Renvoie SdifF->CurrMtrx->NbCol, nombre de colonnes de la matrice en
    #   cours de traitement.  */
    DIF_API SdifUInt4 SdifFCurrNbCol (SdifFileT *SdifF)
    # 
    # /*DOC: 
    #   Renvoie SdifF->CurrMtrx->NbRow, nombre de lignes de la matrice en
    #   cours de traitement.  */
    SDIF_API SdifUInt4 SdifFCurrNbRow (SdifFileT *SdifF)
    # 
    # /*DOC: 
    #   Returns the data type of the current matrix. */
    SDIF_API SdifDataTypeET SdifFCurrDataType (SdifFileT *SdifF)
    # 
    # /*DOC: 
    #   Renvoie SdifF->CurrFramH->NbMatrix, mombre de matrices du frame
    #   courant.  */
    SDIF_API SdifUInt4 SdifFCurrNbMatrix (SdifFileT *SdifF)
    # 
    # /*DOC: 
    #   Renvoie SdifF->CurrFramH->NumID, index de l'objet du frame courant.  */
    SDIF_API SdifUInt4 SdifFCurrID (SdifFileT *SdifF)
    # 
    # /*DOC: 
    #   Renvoie SdifF->CurrFramH->Time.  */
    SDIF_API SdifFloat8 SdifFCurrTime (SdifFileT *SdifF)
    # 
    # 
    # 
    # 
    # /*
    # // FUNCTION GROUP:      File Data Access Functions
    # */
    # 
    # /*DOC: 
    #   Renvoie la ligne temporaire de SdifF.  */
    SDIF_API SdifOneRowT* SdifFCurrOneRow (SdifFileT *SdifF)
    # 
    # /*DOC:
    #   Returns a pointer to the data of the current matrix row.  
    #   According to the matrix data type, it can be a pointer to float or double. */
    SDIF_API void* SdifFCurrOneRowData (SdifFileT *SdifF)
    # 
    # /*DOC: 
    #   Return pointer to current matrix data structure, if read before with
    #   SdifFReadMatrixData. */
    SDIF_API SdifMatrixDataT *SdifFCurrMatrixData (SdifFileT *file)
    # 
    # /*DOC: 
    #   Return pointer to current raw matrix data, if read before with
    #   SdifFReadMatrixData.  Data is specified by current matrix header */
    SDIF_API void* SdifFCurrMatrixDataPointer (SdifFileT *file)
    # 
    # 
    # /*DOC:
    #   Return list of NVTs for querying. 
    #   [] precondition NVTs have been read with SdifFReadAllASCIIChunks. */
    SDIF_API SdifNameValuesLT *SdifFNameValueList (SdifFileT *file)
    # 
    # /*DOC:
    #   Return number of NVTs present.
    #   [] precondition NVTs have been read with SdifFReadAllASCIIChunks. */
    SDIF_API int SdifFNameValueNum (SdifFileT *file)
    # 
    # /*DOC:
    #   Return the file's stream ID table, created automatically by SdifFOpen. */
    SDIF_API SdifStreamIDTableT *SdifFStreamIDTable (SdifFileT *file)
    # 
    # /*DOC:
    #   Add user data, return index added */
    SDIF_API int SdifFAddUserData (SdifFileT *file, void *data);
    # 
    # /*DOC:
    #   Get user data by index */
    SDIF_API void *SdifFGetUserData (SdifFileT *file, int index);

    DIF_API SdifFileT*    SdifFReInitMtrxUsed (SdifFileT *SdifF);
    SDIF_API SdifFileT*    SdifFPutInMtrxUsed  (SdifFileT *SdifF, SdifSignature Sign);
    SDIF_API SdifSignature SdifFIsInMtrxUsed   (SdifFileT *SdifF, SdifSignature Sign);
    # 
    # 
    # 
    # /*
    # // FUNCTION GROUP:      Error flag for file
    # */
    # 
    # /*DOC: 
    #   Return pointer to last error struct or NULL if no error present
    #   for this file. */
    SDIF_API SdifErrorT* SdifFLastError (SdifFileT *SdifF);
    # 
    # /*DOC: 
    # Return tag of last error or eNoError if no error present for this file. */
    SDIF_API SdifErrorTagET  SdifFLastErrorTag (SdifFileT *SdifF)



    #define _SdifFrameHeaderSize 16  /* (ID=4)+(size=4)+(time=8) */
    DEF _SdifFrameHeaderSize=16



    SDIF_API SdifFrameHeaderT* SdifCreateFrameHeader(SdifSignature Signature,
                                                SdifUInt4 Size,
                                                SdifUInt4 NbMatrix,
                                                SdifUInt4 NumID,
                                                SdifFloat8 Time)

    SDIF_API SdifFrameHeaderT* SdifCreateFrameHeaderEmpty(SdifSignature Signature)
    # 
    SDIF_API void              SdifKillFrameHeader  (SdifFrameHeaderT *FrameHeader);
    # 
    SDIF_API SdifFrameDataT* SdifCreateFrameData(SdifHashTableT *FrameTypesTable,
                                                SdifSignature FrameSignature,
                                                SdifUInt4 NumID,
                                                SdifFloat8 Time)
    # 
    SDIF_API void SdifKillFrameData (SdifHashTableT *FrameTypesTable, SdifFrameDataT *FrameData)
    # 
    SDIF_API SdifFrameDataT* SdifFrameDataPutNthMatrixData(SdifFrameDataT *FrameData, unsigned int NthMatrix,
                                                          SdifMatrixDataT *MatrixData)
    # 
    SDIF_API SdifFrameDataT* SdifFrameDataPutComponentMatrixData(SdifHashTableT *FrameTypesTable,
                                                                SdifFrameDataT *FrameData,
                                                                char *CompoName, SdifMatrixDataT *MatrixData)
    # 
    SDIF_API SdifMatrixDataT* SdifFrameDataGetNthMatrixData(SdifFrameDataT *FrameData, unsigned int NthMatrix)
    # 
    SDIF_API SdifMatrixDataT* SdifFrameDataGetComponentMatrixData(SdifHashTableT *FrameTypesTable,
                                                                 SdifFrameDataT *FrameData,
                                                          char *CompoName)
    # 
    # 
    # 
    SDIF_API SdifComponentT* SdifCreateComponent (SdifSignature MtrxS, char *Name, SdifUInt4 Num)
    SDIF_API void            SdifKillComponent   (SdifComponentT *Component)
    SDIF_API SdifFrameTypeT* SdifCreateFrameType (SdifSignature FramS, SdifFrameTypeT *PredefinedFrameType)
    # 
    SDIF_API void            SdifKillFrameType   (SdifFrameTypeT *FrameType)
    # 
    # /**
    #  * Get number of matrix components defined in frame type. 
    #  */
    SdifUInt4 SdifFrameTypeGetNbComponents (SdifFrameTypeT *FrameType)
    # 
    # /** 
    #  * Access a frame type component definition by matrix component number (starting from 1).
    #  */
    SDIF_API SdifComponentT* SdifFrameTypeGetNthComponent    (SdifFrameTypeT *FrameType, SdifUInt4 NumC)
    # 
    # /** 
    #  * Access a frame type component definition by matrix component signature 
    #  */
    SDIF_API SdifComponentT* SdifFrameTypeGetComponent_MtrxS (SdifFrameTypeT *FrameType, SdifSignature MtrxS)
    # 
    # /** 
    #  * Access a frame type component definition by matrix component name 
    #  */
    SDIF_API SdifComponentT* SdifFrameTypeGetComponent       (SdifFrameTypeT *FrameType, const_char_ptr NameC)
    # 
    SDIF_API SdifFrameTypeT* SdifFrameTypePutComponent       (SdifFrameTypeT *FrameType, SdifSignature MtrxS, char *NameC)
    # 
    # 
    # /** Get matrix signature of frame component definition */
    SdifSignature SdifFrameTypeGetComponentSignature (SdifComponentT *comp)
    # 
    # /** Get matrix role of frame component definition */
    char *SdifFrameTypeGetComponentName (SdifComponentT *comp);
    # 
    # 
    # /**
    #  * Get frame type pointer from signature, given a frame type hash table.
    #  * Use SdifFGetFrameTypesTable to get this.
    #  */ 
    SDIF_API SdifFrameTypeT* SdifGetFrameType       (SdifHashTableT *FrameTypeHT, SdifSignature FramS)
    # 
    SDIF_API void            SdifPutFrameType       (SdifHashTableT *FrameTypeHT, SdifFrameTypeT *FrameType)
    SDIF_API SdifUInt2       SdifExistUserFrameType (SdifHashTableT *FrameTypeHT);
    # 
    # 
    # 
    # /* set default if not overridden from makefile */
    # #ifndef _SdifFormatVersion
    # #define _SdifFormatVersion 3
    # #endif
    DEF _SdifFormatVersion = 3
    # 
    # #define _SdifTypesVersion  1
    DEF _SdifTypesVersion = 1
    # 
    # 
    # /* _SdifEnvVar : Environnement variable which contains the name
    #  * of the file which contains predefined types (the name contains the path).
    #  * _SdifEnvVar is used in SdifFile.c SdifGenInit, the user can
    #  * reference predefined types by this envvar name.
    #  */
    # #define _SdifEnvVar "SDIFTYPES"
    DEF _SdifEnvVar = "SDIFTYPES"
    # 
    # /* Default predefined types : _SdifTypesFileName see SdifFile.c
    #  */
    # 
    # /* allocation constants
    #    TODO: should these be public? */
    # #define _SdifListNodeStockSize 0x400 /* 1024 */
    DEF _SdifListNodeStockSize  = 0x400
    # #define _SdifGenHashSize         127 /* size of matrix/frame type table */
    DEF _SdifGenHashSize        = 127
    # #define _SdifNameValueHashSize    31 /* size of hash table for NVTs */
    DEF _SdifNameValueHashSize  = 31
    # #define _SdifUnknownSize  0xffffffff
    DEF _SdifUnknownSize        = 0xffffffff
    # #define _SdifGranule            1024 /* for OneRow allocation in bytes */
    DEF _SdifGranule            = 1024
    # #define _SdifPadding               8
    DEF _SdifPadding            = 8
    # #define _SdifPaddingBitMask (_SdifPadding - 1)
    DEF _SdifPaddingBitMask     = _SdifPadding - 1
    # 
    # #define _SdifFloat8Error  0xffffffff
    DEF _SdifFloat8Error        = 0xffffffff
    # #define _SdifNoTime       _Sdif_MIN_DOUBLE_     /* for header ASCII frames */
    #DEF _SdifNoTime                = _Sdif_MIN_DOUBLE_
    # #define _SdifNoStreamID   0xfffffffe            /* -2 used for 1TYP */
    DEF _SdifNoStreamID = 0xfffffffe
    # #define _SdifAllStreamID  0xffffffff            /* -1 used for 1IDS */
    DEF _SdifAllStreamID = 0xffffffff
    # #define _SdifUnknownUInt4 0xffffffff
    DEF _SdifUnknownUInt4 = 0xffffffff
    # 
    # /* CNMAT restriction: only one frame type per stream.  
    #    Therefore we have to use unique IDs for all 'header' frames. */
    # #define _SdifNVTStreamID  0xfffffffd            /* -3 used for 1NVT */
    DEF _SdifNVTStreamID = 0xfffffffd
    # #define _SdifIDSStreamID  0xfffffffc            /* -4 unused */
    DEF _SdifIDSStreamID = 0xfffffffc
    # #define _SdifTYPStreamID  0xfffffffb            /* -5 unused */
    DEF _SdifTYPStreamID = 0xfffffffb
    # 
    # 
    # #define _SdifFloatEps  FLT_EPSILON
    DEF _SdifFloatEps = FLT_EPSILON
    
    # 
    # /* DataTypeEnum
    # 
    #    On Matt Wright's visit at IRCAM June 1999, we defined a new
    #    encoding for the MatrixDataType field with the feature that the low
    #    order byte encodes the number of bytes taken by each matrix
    #    element.  
    # 
    #    Low order byte encodes the number of bytes 
    #    High order bytes come from this (extensible) enum:
    # 
    #         0 : Float
    #         1 : Signed integer
    #         2 : Unsigned integer
    #         3 : Text (UTF-8 when 1 byte)
    #         4 : arbitrary/void
    # */
    # 
    # 
    # #ifndef SWIG
    # /* #ifdef STDC_HEADERS */  /* Is the compiler ANSI? */
    # 
    # /* generate template for all types, 
    #    called by sdif_foralltypes and sdif_proto_foralltypes. */
    # #define sdif__foralltypes(macro, post)  macro(Float4)post \
    #                                         macro(Float8)post \
    #                                         macro(Int1  )post \
    #                                         macro(Int2  )post \
    #                                         macro(Int4  )post \
    #                                         macro(UInt1 )post \
    #                                         macro(UInt2 )post \
    #                                         macro(UInt4 )post \
    #                                         macro(Char  )post \
    #                                      /* macro(Int8  )post \
    #                                         macro(UInt8 )post \
    #                                       */
    # 
    # #define sdif_foralltypes_post_body    /* this is empty */
    # #define sdif_foralltypes_post_proto ; /* this is a semicolon */
    # 
    # 
    # /* generate template for all types */
    # #define sdif_foralltypes(macro)         \
    #         sdif__foralltypes(macro,sdif_foralltypes_post_body)
    # 
    # 
    # /* generate prototype template for all types */
    # #define sdif_proto_foralltypes(macro)   \
    #         sdif__foralltypes(macro,sdif_foralltypes_post_proto)
    # 
    # /* #endif */ /* STDC_HEADERS */
    # #endif /* SWIG */
    # 
    # 
    # #define _SdifStringLen 1024
    DEF _SdifStringLen = 1024
    # 
    # extern SDIF_API char gSdifString[_SdifStringLen];
    char gSdifString[_SdifStringLen]
    # extern SDIF_API char gSdifString2[_SdifStringLen];
    char gSdifString2[_SdifStringLen]
    # extern SDIF_API char gSdifErrorMess[_SdifStringLen];
    char gSdifErrorMess[_SdifStringLen]
    # 
    # #define _SdifNbMaxPrintSignature 8
    DEF _SdifNbMaxPrintSignature = 8
    # extern SDIF_API char gSdifStringSignature[_SdifNbMaxPrintSignature][5];
    char gSdifStringSignature[_SdifNbMaxPrintSignature][5]
    # extern SDIF_API int  CurrStringPosSignature;
    int  CurrStringPosSignature
    # 
    # 
    # /*
    # // FUNCTION GROUP:      utility functions
    # */
    # 
    # /*DOC:
    # */
    # SDIF_API char*     SdifSignatureToString(SdifSignature Signature);
    SDIF_API char* SdifSignatureToString(SdifSignature Signature)
    # 
    # /*DOC: 
    #   Compare two signatures, ignoring the first character which
    #   encodes the type version.  Note that comparison of full signatures
    #   can be done simply with '=='. 
    # */
    # SDIF_API int     SdifSignatureCmpNoVersion(SdifSignature Signature1, SdifSignature Signature2);
    SDIF_API int     SdifSignatureCmpNoVersion(SdifSignature Signature1, SdifSignature Signature2)
    # 
    # /*DOC: 
    #   Returns size of SDIF data type in bytes
    #   (which is always the low-order byte).  
    # */
    # SDIF_API SdifUInt4 SdifSizeofDataType (SdifDataTypeET DataType);
    SDIF_API SdifUInt4 SdifSizeofDataType (SdifDataTypeET DataType)
    # 
    # /*DOC: 
    #   Returns true if DataType is in the list of known data types.
    # */
    # SDIF_API int SdifDataTypeKnown (SdifDataTypeET DataType);
    SDIF_API int SdifDataTypeKnown (SdifDataTypeET DataType)
    # 
    # /*DOC:
    # */
    # SDIF_API size_t    SdifPaddingCalculate  (size_t NbBytes);
    SDIF_API size_t    SdifPaddingCalculate  (size_t NbBytes)
    # 
    # /*DOC:
    # */
    # SDIF_API size_t    SdifFPaddingCalculate (FILE *f, size_t NbBytes);
    SDIF_API size_t    SdifFPaddingCalculate (FILE *f, size_t NbBytes)
    # 
    # /* (double f1) == (double f2) with _SdifFloatEps for error */
    # SDIF_API int SdifFloat8Equ(SdifFloat8 f1, SdifFloat8 f2);
    # 
    # 
    # #ifndef MIN
    # #define MIN(a,b)        ((a) < (b)  ?  (a)  :  (b))
    # #endif
    # 
    # #ifndef MAX
    # #define MAX(a,b)        ((a) > (b)  ?  (a)  :  (b))
    # #endif
    # 
    # 
    # 
    # /* SdifHard_OS.h */
    # 
    # /* _Sdif_MIN_DOUBLE_ tested on SGI, DEC alpha, PCWin95 as 0xffefffffffffffff
    #  * include may be limits.h (float.h is sure with VisualC++5 Win 95 or NT)
    #  */
    # #define _Sdif_MIN_DOUBLE_ (- DBL_MAX)
    DEF _Sdif_MIN_DOUBLE_ = -DBL_MAX
    DEF _SdifNoTime       = _Sdif_MIN_DOUBLE_
    # 
    # 
    # SDIF_API int       SdifStrLen  (const_char_ptr s);
    SDIF_API int SdifStrLen  (const_char_ptr s)
    # 
    # /* returns 0 if strings are equal */
    # SDIF_API int       SdifStrCmp  (const_char_ptr s1, const_char_ptr s2);
    SDIF_API int       SdifStrCmp  (const_char_ptr s1, const_char_ptr s2)
    # 
    # /* returns true if strings are equal */
    # SDIF_API int       SdifStrEq(const_char_ptr s1, const_char_ptr s2);
    SDIF_API int       SdifStrEq(const_char_ptr s1, const_char_ptr s2)
    # SDIF_API int       SdifStrNCmp (const_char_ptr s1, const_char_ptr s2, unsigned int n);
    SDIF_API int       SdifStrNCmp (const_char_ptr s1, const_char_ptr s2, unsigned int n)
    # SDIF_API char*     SdifStrNCpy (char *s1, const_char_ptr s2, unsigned int n);
    SDIF_API char*     SdifStrNCpy (char *s1, const_char_ptr s2, unsigned int n)
    # SDIF_API char*     SdifCreateStrNCpy (const char* Source, size_t Size);
    SDIF_API char*     SdifCreateStrNCpy (const_char_ptr Source, size_t Size)
    
    # SDIF_API void      SdifKillStr (char* String);
    SDIF_API void      SdifKillStr (char* String)
    # 
    # 
    # SDIF_API void     SdifSetStdIOBinary (void);
    SDIF_API void     SdifSetStdIOBinary (void)
    # SDIF_API FILE*    SdiffBinOpen       (const_char_ptr  Name, SdifBinaryModeET Mode);
    SDIF_API FILE*    SdiffBinOpen       (const_char_ptr Name, SdifBinaryModeET Mode)
    # SDIF_API SdifInt4 SdiffBinClose      (FILE *f);
    SDIF_API SdifInt4 SdiffBinClose      (FILE *f)
    # 
    # 
    # 
    SDIF_API SdifHashTableT* SdifCreateHashTable(unsigned int HashSize, SdifHashIndexTypeET IndexType, void (*Killer)(void *))
    # 
    SDIF_API void SdifMakeEmptyHashTable (SdifHashTableT* HTable);
    SDIF_API void SdifKillHashTable      (SdifHashTableT* HTable);
    SDIF_API unsigned int SdifHashTableGetNbData  (SdifHashTableT* HTable);
    # 
    # /*DOC:
    #   Allocate and initialise hash table iterator, return pointer to it */
    SDIF_API SdifHashTableIteratorT* SdifCreateHashTableIterator (SdifHashTableT *HTable)
    # /*DOC:
    #   Deallocate hash table iterator created with SdifCreateHashTableIterator */
    SDIF_API void SdifKillHashTableIterator (SdifHashTableIteratorT *iter);
    # /*DOC:
    #   Initialise hash table iterator given by pointer.
    #   [Returns] true if hash table has elements. */
    SDIF_API int  SdifHashTableIteratorInitLoop (SdifHashTableIteratorT *iter, 
    #                        SdifHashTableT *HTable);
    # 
    # /*DOC:
    #   Test if iterator has more elements */
    SDIF_API int  SdifHashTableIteratorIsNext (SdifHashTableIteratorT *iter)
    # 
    # /*DOC:
    #   Return current Data pointer and advance iterator */
    SDIF_API void* SdifHashTableIteratorGetNext (SdifHashTableIteratorT *iter)
    # 
    # 
    # 
    # /******************  eHashChar ****************/
    # 
    SDIF_API unsigned int SdifHashChar(const_char_ptr s, unsigned int nchar, unsigned int HashSize)
    # 
    SDIF_API void*           SdifHashTableSearchChar(SdifHashTableT* HTable, const_char_ptr s, unsigned int nchar)
    SDIF_API SdifHashTableT* SdifHashTablePutChar   (SdifHashTableT* HTable, const_char_ptr s, unsigned int nchar, void* Data);
    # 
    # 
    # /***************** eHashInt4 **********************/
    # 
    SDIF_API unsigned int SdifHashInt4(unsigned int i, unsigned int HashSize);
    # 
    SDIF_API void*           SdifHashTableSearchInt4(SdifHashTableT* HTable, unsigned int i);
    SDIF_API SdifHashTableT* SdifHashTablePutInt4   (SdifHashTableT* HTable, const_unsigned_int i, void* Data);
    # 
    # 
    # /*************************** for all ***********************/
    # 
    SDIF_API void*           SdifHashTableSearch (SdifHashTableT* HTable, void *ptr, unsigned int nobj)
    SDIF_API SdifHashTableT* SdifHashTablePut    (SdifHashTableT* HTable, const_void_ptr ptr, unsigned int nobj, void* Data);
    # 
    # 
    # 
    # 
    # /*
    # //FUNCTION GROUP:  High-Level I/O Functions
    # */
    # 
    # /*DOC:
    #   Definition of the callback function types, used for SdifReadSimple. 
    #   SdifOpenFileCallbackT returns flag if rest of file should be read.
    # */
    # typedef int (*SdifOpenFileCallbackT)   (SdifFileT *file, void *userdata);
    ctypedef int (*SdifOpenFileCallbackT) (SdifFileT *file, void *userdata)
    # typedef int (*SdifCloseFileCallbackT)  (SdifFileT *file, void *userdata);
    ctypedef int (*SdifCloseFileCallbackT)  (SdifFileT *file, void *userdata)
    # typedef int (*SdifFrameCallbackT)      (SdifFileT *file, void *userdata);
    ctypedef int (*SdifFrameCallbackT)      (SdifFileT *file, void *userdata)
    # typedef int (*SdifMatrixCallbackT)     (SdifFileT *file, 
    #                                         int nummatrix,   void *userdata);
    ctypedef int (*SdifMatrixCallbackT)     (SdifFileT *file, 
                                             int nummatrix,   void *userdata)
    # typedef int (*SdifMatrixDataCallbackT) (SdifFileT *file, 
    #                                         int nummatrix,   void *userdata);
    ctypedef int (*SdifMatrixDataCallbackT) (SdifFileT *file, int nummatrix, void *userdata)
    # 
    # /*DOC: 
    #   Reads an entire SDIF file, calling matrixfunc for each matrix in the
    #   SDIF selection taken from the filename.  Matrixfunc is called with
    #   the SDIF file pointer, the matrix count within the current frame,
    #   and the userdata unchanged. 
    # 
    #   no row/column selection yet!
    #   
    #   @return number of bytes read
    # */
    SDIF_API size_t SdifReadSimple (const_char_ptr filename, 
                                     SdifMatrixDataCallbackT  matrixfunc,
                                     void                    *userdata)
    # 
    # 
    SDIF_API size_t SdifReadFile   (const_char_ptr filename, 
                                    SdifOpenFileCallbackT    openfilefunc,
                                    SdifFrameCallbackT       framefunc,
                                    SdifMatrixCallbackT      matrixfunc,
                                    SdifMatrixDataCallbackT  matrixdatafunc,
                                    SdifCloseFileCallbackT   closefilefunc,
                                    void                    *userdata)
    # 
    # /*DOC: 
    #   Reads matrix data and padding.  The data is stored in CurrMtrxData,
    #   for which the library will allocate enough space for the data of one
    #   matrix, accessible by SdifFCurrMatrixData().  
    #   
    #   @return       number of bytes read or 0 if error
    #                 N.B. first of all that an error is signalled to the error callback
    #                 set with SdifSetErrorFunc, and the library tries to exit via the 
    #                 function set with SdifSetExitFunc.  So, if you have to check the
    #                 return value, note that for matrices with 0 rows or 0 columns,
    #                 a return value of 0 is correct.  
    #                 You should thus check for this with:
    # 
    #   if (nread == 0  &&  (SdifFCurrNbRow(file) != 0  ||  SdifFCurrNbCol(file) != 0))
    #       --> read problem
    # 
    #   [Precondition:] 
    #   Matrix header must have been read with SdifFReadMatrixHeader.  
    # */
    SDIF_API size_t SdifFReadMatrixData   (SdifFileT *file)
    # 
    # 
    # 
    # 
    # /*
    # //FUNCTION GROUP:  Querying SDIF Files
    # */
    # 
    # typedef struct
    # { 
    #     double min, max;    /* use double even for int, doesn't harm */
    # } SdifMinMaxT;
    ctypedef struct SdifMinMaxT:
        double min, max
        
    # 
    # /* two-level tree node for matrices in frames */
    # typedef struct SdifQueryTreeElemS
    # {
    #     /* common fields */
    #     SdifSignature sig;
    #     int           count;
    #     int           parent;/* -1 for frames, index to parent frame for matrices */
    # 
    #     /* frame fields */
    #     int           stream;
    #     SdifMinMaxT   time, nmatrix;
    # 
    #     /* matrix fields */
    #     SdifMinMaxT   ncol, nrow;
    # 
    # } SdifQueryTreeElemT;
    struct SdifQueryTreeElemS:
        # common fields 
        SdifSignature sig
        int           count
        int           parent #;/* -1 for frames, index to parent frame for matrices */
        #     /* frame fields */
        int           stream
        SdifMinMaxT   time, nmatrix
        # 
        #     /* matrix fields */
        SdifMinMaxT   ncol, nrow
     
    # /* SdifQueryTreeT counts occurence of signatures as frame or matrix under
    #    different parent frames. */
    # typedef struct
    # {
    #     int                 num;            /* number of elems used */
    #     int                 nummatrix;      /* number of leaf nodes */
    #     int                 current;        /* index of current frame */
    #     int                 allocated;      /* number of elems allocated */
    #     SdifQueryTreeElemT *elems;
    #     SdifMinMaxT         time;           /* frame times */
    # } SdifQueryTreeT;
    ctypedef struct SdifQueryTreeT:
        int                 num  #;            /* number of elems used */
        int                 nummatrix  #;      /* number of leaf nodes */
        int                 current  #;        /* index of current frame */
        int                 allocated  #;      /* number of elems allocated */
        SdifQueryTreeElemT *elems  #;
        SdifMinMaxT         time  #;           /* frame times */
    
    # 
    # 
    # /* allocate query tree for max elements */
    SDIF_API SdifQueryTreeT *SdifCreateQueryTree(int max)
    # 
    # /* clean all elements from tree */
    SDIF_API SdifQueryTreeT *SdifInitQueryTree(SdifQueryTreeT *tree);
    # 
    # /* create summary of file's data in query tree, return bytesize of file */
    SDIF_API size_t SdifQuery (const_char_ptr filename, 
                               SdifOpenFileCallbackT  openfilefunc,
                               SdifQueryTreeT        *tree)
    # 
    # 
    # 
    # 
    # 
    # #if 0   /* TBI */
    # 
    # /*
    # //FUNCTION GROUP: to be implemented / TBI
    # */
    # 
    # 
    # /*DOC: 
    #   Write whole matrix, given as separate columns in array "columns" of
    #   pointer to "DataType".  Each columns [i], i = 0..NbCol-1, points to 
    #   NbRow * SdifSizeofDataType (DataType) bytes.  
    #   TBI 
    # */
    # SdifFWriteMatrixColumns (SdifFileT     *file,
    #                          SdifSignature  Signature,
    #                          SdifDataTypeET DataType,
    #                          SdifUInt4      NbRow,
    #                          SdifUInt4      NbCol,
    #                          void          *columns []);
    # 
    # 
    # /*DOC: 
    #   Reads matrix header and data into memory allocated by the library,
    #   accessible by SdifFCurrMatrixData (). */
    # int SdifFReadMatrix (SdifFileT *file);
    # 
    # void *SdifGetColumn ();
    # 
    # 
    # 
    # /*
    #  * Error handling (sketch TBI)
    #  */
    # 
    # int /*bool*/ SdifFCheckStatus (SdifFileT *file)
    # {
    #   return (SdifLastError (file->ErrorList)) == NULL);
    # }
    # 
    # 
    # int /*bool*/ SdifFCheckStatusPrint (SdifFileT *file)
    # {
    #   SdifError err = SdifLastError (file->ErrorList));
    #   if (err != eNoError)
    #      print (SdifFsPrintFirstError (..., file, ...);
    #   return err == NULL;
    # }
    # 
    # 
    # /* --> test in SdifFReadGeneralHeader  (file) + SdifFReadAllASCIIChunks (file)
    #    if (!SdifFCheckStatus (file))
    #       SdifWarningAdd ("Followup error");
    # */
    # 
    # #endif /* TBI */
    # 
    # 
    # 
    # /* stocks management */
    # 
    SDIF_API void        SdifInitListNStock      (SdifListNStockT *Stock, unsigned int SizeOfOneStock);
    SDIF_API void        SdifNewStock            (SdifListNStockT *Stock);
    SDIF_API SdifListNT* SdifGetNewNodeFromTrash (SdifListNStockT *Stock);
    SDIF_API SdifListNT* SdifGetNewNodeFromStock (SdifListNStockT *Stock);
    SDIF_API SdifListNT* SdifGetNewNode          (SdifListNStockT *Stock);
    SDIF_API void        SdifPutNodeInTrash      (SdifListNStockT *Stock, SdifListNT* OldNode);
    SDIF_API SdifListNT* SdifKillListNStock      (SdifListNT* OldStock);
    SDIF_API void        SdifListNStockMakeEmpty (SdifListNStockT *Stock);
    # 
    # /* global variable gSdifListNodeStock */
    # 
    # extern SDIF_API SdifListNStockT gSdifListNodeStock;
    SdifListNStockT gSdifListNodeStock
    
    SDIF_API SdifListNStockT* SdifListNodeStock  (void);
    SDIF_API void    SdifInitListNodeStock       (unsigned int SizeOfOneStock);
    SDIF_API void    SdifDrainListNodeStock      (void);
    # 
    # 
    # /* nodes management */
    # 
    SDIF_API SdifListNT* SdifCreateListNode  (SdifListNT *Next, void *Data);
    SDIF_API SdifListNT* SdifKillListNode    (SdifListNT *Node, KillerFT Killer);
    # 
    # 
    # 
    # /* lists management */
    # 
    SDIF_API SdifListT*  SdifCreateList      (KillerFT Killer);
    SDIF_API SdifListT*  SdifKillListHead    (SdifListT* List);
    SDIF_API SdifListT*  SdifKillListCurr    (SdifListT* List);
    SDIF_API SdifListT*  SdifMakeEmptyList   (SdifListT* List);
    SDIF_API void        SdifKillList        (SdifListT* List);
    # 
    # /*DOC:
    #   Init the function SdifListGetNext. 
    #   [Return] head of List. */
    SDIF_API void*       SdifListGetHead     (SdifListT* List); 
    # 
    SDIF_API void*       SdifListGetTail     (SdifListT* List);
    SDIF_API int         SdifListIsNext      (SdifListT* List);
    SDIF_API int         SdifListIsEmpty     (SdifListT* List);
    SDIF_API unsigned int SdifListGetNbData  (SdifListT* List);
    # 
    # /*DOC:
    #   Init for function SdifListGetNext.
    #   [Returns] true if List has elements. */
    SDIF_API int         SdifListInitLoop    (SdifListT* List);
    # 
    # /*DOC:
    #   Set Curr to Curr->Next and after return Curr->Data */
    SDIF_API void*       SdifListGetNext     (SdifListT* List);
    # 
    # /*DOC:
    #   Only return Curr->Data. */
    SDIF_API void*       SdifListGetCurr     (SdifListT* List);
    # 
    SDIF_API SdifListT*  SdifListPutTail     (SdifListT* List, void *pData);
    SDIF_API SdifListT*  SdifListPutHead     (SdifListT* List, void *pData);
    # 
    # /*DOC:
    #   append list b to list a 
    # 
    #   WARNING: This creates double references to the data! */
    SDIF_API SdifListT *SdifListConcat(SdifListT *a, SdifListT *b);
    # 
    # 
    # 
    # 
    SDIF_API SdifMatrixHeaderT* SdifCreateMatrixHeader (SdifSignature Signature, 
                                                        SdifDataTypeET DataType,
                                                        SdifUInt4 NbRow, 
                                                        SdifUInt4 NbCol)
    # 
    SDIF_API SdifMatrixHeaderT* SdifCreateMatrixHeaderEmpty (void)
    SDIF_API void               SdifKillMatrixHeader        (SdifMatrixHeaderT *MatrixHeader)
    # 
    # 
    # /*
    #  * OneRow class
    #  */
    # 
    SDIF_API SdifOneRowT*       SdifCreateOneRow          (SdifDataTypeET DataType, SdifUInt4  NbGranuleAlloc)
    SDIF_API SdifOneRowT*       SdifReInitOneRow          (SdifOneRowT *OneRow, SdifDataTypeET DataType, SdifUInt4 NbData)
    SDIF_API void               SdifKillOneRow            (SdifOneRowT *OneRow)
    # 
    # /* row element access */
    # 
    SDIF_API SdifOneRowT*       SdifOneRowPutValue        (SdifOneRowT *OneRow, SdifUInt4 numCol, SdifFloat8 Value)
    SDIF_API SdifFloat8         SdifOneRowGetValue        (SdifOneRowT *OneRow, SdifUInt4 numCol)
    SDIF_API SdifFloat8         SdifOneRowGetValueColName (SdifOneRowT *OneRow, SdifMatrixTypeT *MatrixType, char * NameCD)
    # 
    # 
    # /*
    #  * matrix data class 
    #  */
    # 
    SDIF_API SdifMatrixDataT* SdifCreateMatrixData (SdifSignature Signature, 
                                                    SdifDataTypeET DataType,
                                                    SdifUInt4 NbRow, 
                                                    SdifUInt4 NbCol)
    # 
    SDIF_API void               SdifKillMatrixData        (SdifMatrixDataT *MatrixData)
    # 
    # /* see if there's enough space for data, if not, grow buffer */
    SDIF_API int                SdifMatrixDataRealloc     (SdifMatrixDataT *data, 
                                                           int newsize)
    # 
    # /* matrix data element access by index (starting from 1!) */
    # 
    SDIF_API SdifMatrixDataT*   SdifMatrixDataPutValue    (SdifMatrixDataT *MatrixData,
                                                           SdifUInt4  numRow, 
                                                           SdifUInt4  numCol, 
                                                           SdifFloat8 Value)
    # 
    SDIF_API SdifFloat8         SdifMatrixDataGetValue    (SdifMatrixDataT *MatrixData,
                                                   SdifUInt4  numRow, 
                                                   SdifUInt4  numCol)
    # 
    # /* matrix data element access by column name */
    # 
    SDIF_API SdifMatrixDataT *  SdifMatrixDataColNamePutValue (SdifHashTableT *MatrixTypesTable,
                                                      SdifMatrixDataT *MatrixData,
                                                      SdifUInt4  numRow,
                                                      char *ColName,
                                                      SdifFloat8 Value)
    # 
    SDIF_API SdifFloat8         SdifMatrixDataColNameGetValue (SdifHashTableT *MatrixTypesTable,
                                                       SdifMatrixDataT *MatrixData,
                                                       SdifUInt4  numRow,
                                                       char *ColName)
    # 
    SDIF_API void      SdifCopyMatrixDataToFloat4    (SdifMatrixDataT *data, 
                                                      SdifFloat4      *dest)
    # 
    # 
    SDIF_API SdifColumnDefT*  SdifCreateColumnDef (const_char_ptr *Name,  unsigned int Num)
    SDIF_API void             SdifKillColumnDef   (void *ColumnDef)
    # 
    # /*DOC: 
    #   premet de créer un objet 'type de matrice'. Le premier argument
    #   est la signature de ce type. Le second est l'objet 'type de matrice'
    #   prédéfini dans SDIF.<p>
    #   
    #   <strong>Important: Tous les types de matrices ou de frames utilisés
    #   dans une instance de SdifFileT doivent être ajoutés aux tables de
    #   cette instance, de façon a créer le lien avec les types
    #   prédéfinis.</strong> L'hors de la lecture des entêtes avec les
    #   fonctions SdifFReadMatrixHeader et SdifFReadFrameHeader, cette mise
    #   à jour se fait automatiquement à l'aide des fonctions
    #   SdifTestMatrixType et SdifTestFrameType. */
    SDIF_API SdifMatrixTypeT* SdifCreateMatrixType              (SdifSignature Signature,
                                                                 SdifMatrixTypeT *PredefinedMatrixType)
    SDIF_API void             SdifKillMatrixType                (SdifMatrixTypeT *MatrixType)
    # 
    # /*DOC: 
    #   permet d'ajouter une colonne à un type (toujours la dernière
    #   colonne).  */
    SDIF_API SdifMatrixTypeT* SdifMatrixTypeInsertTailColumnDef (SdifMatrixTypeT *MatrixType, const_char_ptr NameCD)
    # 
    # /*DOC: 
    #   Return number of columns defined for given matrix type. */
    SdifUInt4 SdifMatrixTypeGetNbColumns (SdifMatrixTypeT *mtype)
    # 
    # /*DOC: 
    #   Get index (starting from 1) of the column given by NameCD (0 if not found) */
    SDIF_API SdifUInt4        SdifMatrixTypeGetNumColumnDef     (SdifMatrixTypeT *MatrixType, const_char_ptr NameCD)
    # 
    # /*DOC: 
    #   Get definition of column from NameCD (NULL if not found) */
    SDIF_API SdifColumnDefT*  SdifMatrixTypeGetColumnDef        (SdifMatrixTypeT *MatrixType, const_char_ptr NameCD)
    # 
    # /*DOC: 
    #   Get definition of column from index (starting from 1) (NULL if not found) */
    SDIF_API SdifColumnDefT*  SdifMatrixTypeGetNthColumnDef     (SdifMatrixTypeT *MatrixType, SdifUInt4 NumCD)
    # 
    # /*DOC: 
    #   Return pointer to name of column at index, NULL if it doesn't exist. */
    SDIF_API const_char_ptr SdifMatrixTypeGetColumnName           (SdifMatrixTypeT *MatrixType, int index)
    # 
    # 
    # /*DOC: 
    #   renvoie le type de matrice en fonction de la Signature. Renvoie
    #   NULL si le type est introuvable. Attention, si Signature est la
    #   signature d'un type prédéfini,
    #   SdifGetMatrixType(SdifF->MatrixTypeTable,Signature) renvoie NULL si
    #   le lien avec entre SdifF et gSdifPredefinedType n'a pas été mis à
    #   jour.  
    # 
    #   Tip: use SdifFGetMatrixTypesTable to obtain the matrix types hash table.
    # */
    SDIF_API SdifMatrixTypeT* SdifGetMatrixType                 (SdifHashTableT *MatrixTypesTable, 
                                                         SdifSignature Signature)
    # 
    # /*DOC: 
    #   permet d'ajouter un type de matrice dans une table.  */
    SDIF_API void             SdifPutMatrixType(SdifHashTableT *MatrixTypesTable, SdifMatrixTypeT* MatrixType)
    SDIF_API SdifUInt2        SdifExistUserMatrixType(SdifHashTableT *MatrixTypesTable)
    # 
    # /*DOC:
    #   Remark:
    #          This function implements the new SDIF Specification (June 1999):
    #        Name Value Table, Matrix and Frame Type declaration, Stream ID declaration are
    #        defined in text matrix:
    #        1NVT 1NVT
    #        1TYP 1TYP
    #        1IDS 1IDS
    #   Get all types from a SdifStringT
    # */
    SDIF_API size_t SdifFGetAllTypefromSdifString (SdifFileT *SdifF, 
                                                   SdifStringT *SdifString)
    # 
    # 
    # 
    # /**
    #  * Get table of matrix type definitions, 
    #  * useful for SdifGetMatrixType. 
    #  *
    #  * @ingroup types
    #  */
    # SDIF_API SdifHashTableT *SdifFGetMatrixTypesTable(SdifFileT *file);
    # 
    # /**
    #  * Get table of frame type definitions declare in this file's header only, 
    #  * useful for SdifGetFrameType. 
    #  *
    #  * @ingroup types
    #  */
    SDIF_API SdifHashTableT *SdifFGetFrameTypesTable(SdifFileT *file)
    # 
    # 
    # 
    # /*
    #  * Memory allocation wrappers
    #  */
    # 
    # #define SdifMalloc(_type) (_type*) malloc(sizeof(_type))
    # 
    # #define SdifCalloc(_type, _nbobj) (_type*) calloc(_nbobj, sizeof(_type))
    # 
    # #define SdifRealloc(_ptr, _type, _nbobj) (_type*) realloc(_ptr, sizeof(_type) * _nbobj)
    # 
    # #define SdifFree(_ptr) free(_ptr)
    # 
    # 
    # 
    # 
    # /*
    #  * NameValue
    #  */
    # 
    # 
    SDIF_API SdifNameValueT* SdifCreateNameValue(const_char_ptr Name, const_char_ptr Value)
    SDIF_API void            SdifKillNameValue(SdifNameValueT *NameValue)
    # 
    # 
    # 
    # 
    # /*
    #  * NameValueTable
    #  */
    # 
    SDIF_API SdifNameValueTableT* SdifCreateNameValueTable(  SdifUInt4 StreamID, 
                                                     SdifUInt4 HashSize, 
                                                     SdifUInt4 NumTable)
    SDIF_API void            SdifKillNameValueTable          (void* NVTable)
    SDIF_API SdifNameValueT* SdifNameValueTableGetNV         (SdifNameValueTableT* NVTable, const_char_ptr Name)
    SDIF_API SdifNameValueT* SdifNameValueTablePutNV         (SdifNameValueTableT* NVTable, const_char_ptr Name,  const_char_ptr Value)
    SDIF_API SdifFloat8      SdifNameValueTableGetTime       (SdifNameValueTableT* NVTable)
    SDIF_API SdifUInt4       SdifNameValueTableGetNumTable   (SdifNameValueTableT* NVTable)
    SDIF_API SdifUInt4       SdifNameValueTableGetStreamID  (SdifNameValueTableT* NVTable)
    # 
    # 
    # 
    # /*
    #  * NameValueTableList
    #  */
    # 
    SDIF_API SdifNameValuesLT*   SdifCreateNameValuesL       (SdifUInt4  HashSize)
    SDIF_API void                SdifKillNameValuesL         (SdifNameValuesLT *NameValuesL)
    # 
    # /*DOC: 
    #   Cette fonction permet d'ajouter une nouvelle NVT dans la liste
    #   de tables passée par argument:
    #   <code>SdifNameValuesLNewHT(SdifF->NamefValues);</code><br>
    #   Attention, à l'ouverture de SdifF, il n'y a aucune table dans
    #   SdifF->NamefValues. Il faudra donc au moins en ajouter une pour
    #   pouvoir y mettre des NameValue.  */
    SDIF_API SdifNameValuesLT*   SdifNameValuesLNewTable     (SdifNameValuesLT *NameValuesL, SdifUInt4 StreamID)
    # 
    # /*DOC: 
    #   Cette fonction permet de définir la nième NVT de la liste des
    #   tables comme NVT courante.  */
    SDIF_API SdifNameValueTableT*SdifNameValuesLSetCurrNVT   (SdifNameValuesLT *NameValuesL, SdifUInt4 NumCurrNVT)
    # 
    # 
    # /*DOC:
    #   Kill current NVT from list of NVTs.  
    #   Warning: current nvt is no longer valid afterwards. 
    #            call SdifNameValuesLSetCurrNVT again */
    SDIF_API void SdifNameValuesLKillCurrNVT(SdifNameValuesLT *NameValuesL)
    # 
    # 
    # /*DOC: 
    #   Cette fonction permet de récupérer une Name-Value de la liste
    #   des NVTs en passant le Name en argument.  Dans le cas ou Name est
    #   référencé dans plusieurs NVT, alors c'est la première NVT le
    #   contenant qui sera prise en compte.  Le pointeur retourné est de
    #   type SdifNameValueT qui contient deux champs: Name et Value.  */
    SDIF_API SdifNameValueT*     SdifNameValuesLGet          (SdifNameValuesLT *NameValuesL, char *Name)
    # 
    # /*DOC: 
    #   Cette fonction réalise aussi une requête en fonction de Name
    #   mais uniquement dans la NVT courante.  */
    SDIF_API SdifNameValueT*     SdifNameValuesLGetCurrNVT   (SdifNameValuesLT *NameValuesL, const_char_ptr Name)
    # 
    # /*DOC: 
    #   Cette fonction permet d'ajouter une NameValue à table courante
    #   qui est la dernière table créée ou celle définie en tant que table
    #   courante. Name et Value doivent être des chaines caractères ASCII
    #   sans espacements.  */
    SDIF_API SdifNameValueT*     SdifNameValuesLPutCurrNVT   (SdifNameValuesLT *NameValuesL, const_char_ptr Name,  const_char_ptr Value)
    # 
    # /*DOC: 
    #   Add a Name-Value pair to the current Name-Value Table, while
    #   replacing reserved characters and spaces with underscores "_" 
    #   (using SdifStringToNV).  FYI: The strings are copied. */
    SDIF_API SdifNameValueT*     SdifNameValuesLPutCurrNVTTranslate(SdifNameValuesLT *NameValuesL, const_char_ptr Name,  const_char_ptr Value)
    # 
    SDIF_API SdifUInt2           SdifNameValuesLIsNotEmpty   (SdifNameValuesLT *NameValuesL)
    # 
    # /*DOC:
    #   Get generic SDIF list with SdifNameValueTableT nvt elements from nvt container struct nvtl */
    SDIF_API SdifListT *         SdifNameValueTableList (SdifNameValuesLT *nvtl)
    # 
    # /*DOC:
    #   Get pointer to hash table of one nvt */
    # SDIF_API SdifHashTableT*     SdifNameValueTableGetHashTable (SdifNameValueTableT* NVTable);
    # 
    # 
    # 
    # #define   M_1FQ0_Frequency  "Frequency"
    DEF M_1FQ0_Frequency = "Frequency"
    # #define   M_1FQ0_Mode       "Mode"
    DEF M_1FQ0_Mode = "Mode"
    # #define   M_1FQ0_Hit        "Hit"
    DEF M_1FQ0_Hit = "Hit"
    # 
    # #define   M_1FOF_Frequency  "Frequency"
    DEF M_1FOF_Frequency = "Frequency"
    # #define   M_1FOF_Amplitude  "Amplitude"
    DEF M_1FOF_Amplitude = "Amplitude"
    # #define   M_1FOF_BandWidth  "BandWidth"
    DEF M_1FOF_BandWidth = "BandWidth"
    # #define   M_1FOF_Tex        "Tex"
    DEF M_1FOF_Tex = "Tex"
    # #define   M_1FOF_DebAtt     "DebAtt"
    DEF M_1FOF_DebAtt = "DebAtt"
    # #define   M_1FOF_Atten      "Atten"
    DEF M_1FOF_Atten = "Atten"
    # #define   M_1FOF_Phase      "Phase"
    DEF M_1FOF_Phase = "Phase"
    # 
    # #define   M_1CHA_Channel1   "Channel1"
    DEF M_1CHA_Channel1 = "Channel1"
    # #define   M_1CHA_Channel2   "Channel2"
    DEF M_1CHA_Channel2 = "Channel2"
    # #define   M_1CHA_Channel3   "Channel3"
    DEF M_1CHA_Channel3 = "Channel3"
    # #define   M_1CHA_Channel4   "Channel4"
    DEF M_1CHA_Channel4 = "Channel4"
    # 
    # #define   M_1RES_Frequency  "Frequency"
    DEF M_1RES_Frequency = "Frequency"
    # #define   M_1RES_Amplitude  "Amplitude"
    DEF M_1RES_Amplitude = "Amplitude"
    # #define   M_1RES_BandWidth  "BandWidth"
    DEF M_1RES_BandWidth = "BandWidth"
    # #define   M_1RES_Saliance   "Saliance"
    DEF M_1RES_Saliance = "Saliance"
    # #define   M_1RES_Correction "Correction"
    DEF M_1RES_Correction = "Correction"
    # 
    # #define   M_1DIS_Distribution    "Distribution"
    DEF M_1DIS_Distribution = "Distribution"
    # #define   M_1DIS_Amplitude  "Amplitude"
    DEF M_1DIS_Amplitude = "Amplitude"
    # 
    SDIF_API SdifFrameTypeT* CreateF_1FOB(void)
    SDIF_API SdifFrameTypeT* CreateF_1REB(void)
    SDIF_API SdifFrameTypeT* CreateF_1NOI(void)
    SDIF_API void SdifCreatePredefinedTypes(SdifHashTableT *MatrixTypesHT,
                                            SdifHashTableT *FrameTypesHT)
    # 
    # 
    # 
    # 
    # 
    # /*************** Matrix Type ***************/
    # 
    SDIF_API void SdifPrintMatrixType(FILE *fw, SdifMatrixTypeT *MatrixType)
    SDIF_API void SdifPrintAllMatrixType(FILE *fw, SdifFileT *SdifF)
    # 
    # /*************** Frame Type ***************/
    # 
    SDIF_API void SdifPrintFrameType(FILE *fw, SdifFrameTypeT *FrameType)
    SDIF_API void SdifPrintAllFrameType(FILE *fw, SdifFileT *SdifF)
    # 
    # /********** Matrix **********/
    # 
    SDIF_API void SdifPrintMatrixHeader(FILE *f, SdifMatrixHeaderT *MatrixHeader)
    SDIF_API void SdifPrintOneRow(FILE *f, SdifOneRowT *OneRow)
    SDIF_API void SdifPrintMatrixRows(FILE* f, SdifMatrixDataT *MatrixData)
    # 
    # /********** Frame ***********/
    # 
    SDIF_API void SdifPrintFrameHeader(FILE *f, SdifFrameHeaderT* FrameHeader)
    # 
    # /************ High ***********/
    # 
    SDIF_API void SdifPrintAllType(FILE *fw, SdifFileT *SdifF)
    # 
    # 
    # 
    # 
    # /*DOC:
    #   Return true if c is a reserved char. 
    # */
    SDIF_API int SdifIsAReservedChar (char c)
    # 
    # /*DOC: 
    #   Convert str <strong>in place</strong> so that it doesn't
    #   contain any reserved chars (these become '.') or spaces (these
    #   become '_').
    # 
    #   [] returns str
    # */
    # SDIF_API char *SdifStringToNV (/*in out*/ char *str);
    SDIF_API char *SdifStringToNV (char *str)
    # 
    # /* SdiffGetString lit un fichier jusqu'a un caractere reserve, ne
    #    rempli s que des caracteres non-espacement, renvoie le caractere
    #    reserve, saute les premiers caracteres espacement lus.  Il y a
    #    erreur si fin de fichier ou si un caractere non-espacement et
    #    non-reseve est lu apres un caractere espacement.  ncMax est
    #    typiquement strlen(s)+1.  
    # */
    SDIF_API int SdiffGetString      (FILE* fr, char* s, size_t ncMax, size_t *NbCharRead)
    # 
    # /* retourne le caractere d'erreur */
    SDIF_API int SdiffGetSignature   (FILE* fr, SdifSignature *Signature, size_t *NbCharRead)
    # /*DOC:
    #   Function return the signature in a SdifStringT
    # */
    SDIF_API int SdiffGetSignaturefromSdifString(SdifStringT *SdifString, SdifSignature *Signature)
    # 
    SDIF_API int SdiffGetWordUntil   (FILE* fr, char* s, size_t ncMax, size_t *NbCharRead, const_char_ptr CharsEnd)
    # /*DOC:
    #   Function return the word until in a SdifStringT
    # */
    SDIF_API int SdiffGetWordUntilfromSdifString(SdifStringT *SdifString, char* s, size_t ncMax,const_char_ptr CharsEnd)
    # 
    SDIF_API int SdiffGetStringUntil (FILE* fr, char* s, size_t ncMax, size_t *NbCharRead, const_char_ptr CharsEnd)
    # /*DOC:
    #   Function return the string until in a SdifStringT
    #  */
    SDIF_API int SdiffGetStringUntilfromSdifString(SdifStringT *SdifString, char *s, size_t ncMax,
                                                   const_char_ptr CharsEnd)
    # 
    SDIF_API int SdiffGetStringWeakUntil(FILE* fr, char* s, size_t ncMax, size_t *NbCharRead, const_char_ptr CharsEnd)
    # /*DOC:
    #   Return the weak string until in a SdifStringT
    # */
    SDIF_API int SdiffGetStringWeakUntilfromSdifString(SdifStringT *SdifString, char* s,
                                                       size_t ncMax, const_char_ptr CharsEnd)
    # 
    SDIF_API int SdifSkipASCIIUntil  (FILE* fr, size_t *NbCharRead, char *CharsEnd)
    SDIF_API int SdifSkipASCIIUntilfromSdifString  (SdifStringT *SdifString, size_t *NbCharRead, char *CharsEnd)
    # 
    # 
    # #if 0   /* for cocoon's eyes only */
    # /* scan nobj items of TYPE from stream, return number sucessfully read */
    # size_t SdiffScan_TYPE   (FILE *stream, Sdif_TYPE  *ptr, size_t nobj);
    # size_t SdiffScanFloat4  (FILE *stream, SdifFloat4 *ptr, size_t nobj);
    # size_t SdiffScanFloat8  (FILE *stream, SdifFloat8 *ptr, size_t nobj);
    # #endif
    # 
    # #ifndef SWIG    /* are we scanned by SWIG? */
    # 
    # /* generate function prototypes for all types TYPE for the 
    #    SdiffScan<TYPE> functions */
    # 
    # #define sdif_scanproto(type) \
    # SDIF_API size_t SdiffScan##type (FILE *stream, Sdif##type *ptr, size_t nobj)
    SDIF_API size_t SdiffScanFloat4 (FILE *stream, SdifFloat4 *ptr, size_t nobj)
    SDIF_API size_t SdiffScanFloat8 (FILE *stream, SdifFloat8 *ptr, size_t nobj)
    SDIF_API size_t SdiffScanInt1 (FILE *stream, SdifInt1 *ptr, size_t nobj)
    SDIF_API size_t SdiffScanInt2 (FILE *stream, SdifInt2 *ptr, size_t nobj)
    SDIF_API size_t SdiffScanInt4 (FILE *stream, SdifInt4 *ptr, size_t nobj)
    SDIF_API size_t SdiffScanUInt1 (FILE *stream, SdifUInt1 *ptr, size_t nobj)
    SDIF_API size_t SdiffScanUInt2 (FILE *stream, SdifUInt2 *ptr, size_t nobj)
    SDIF_API size_t SdiffScanUInt4 (FILE *stream, SdifUInt4 *ptr, size_t nobj)
    SDIF_API size_t SdiffScanChar (FILE *stream, SdifChar *ptr, size_t nobj)
    
    
    # 
    # sdif_proto_foralltypes (sdif_scanproto)
    #
    # define sdif__foralltypes(macro, post)  macro(Float4)post \
    #                                         macro(Float8)post \
    #                                         macro(Int1  )post \
    #                                         macro(Int2  )post \
    #                                         macro(Int4  )post \
    #                                         macro(UInt1 )post \
    #                                         macro(UInt2 )post \
    #                                         macro(UInt4 )post \
    #                                         macro(Char  )post \
    #                                      /* macro(Int8  )post \
    #                                         macro(UInt8 )post \
    # 
    # #endif /* SWIG */
    # 
    # 
    # /* Unsafe but optimized version of SdifStringToSignature:
    #    Exactly 4 chars are considered, so make sure *str has at least that many! 
    #    The str pointer MUST be word (at least 4 byte or so) aligned.
    # */
    SDIF_API SdifSignature _SdifStringToSignature (const_char_ptr str);
    # 
    # /*DOC:
    #   Convert a string to an SDIF signature (in proper endianness).
    #   str can point to any string position of any length.  
    # */
    SDIF_API SdifSignature SdifStringToSignature (const_char_ptr str);
    # 
    # 
    # 
    # 
    # 
    # 
    # /*DOC:
    #   Return pointer to start of filename component in path inPathFileName.
    #  */
    SDIF_API char *SdifBaseName (const_char_ptr inPathFileName)
    # 
    # 
    # /* 
    # // FUNCTION GROUP:      Init/Deinit
    #  */
    # 
    # /* init module, called by SdifGenInit */
    SDIF_API int SdifInitSelect (void)
    # 
    # /*DOC: 
    #   Allocate space for an sdif selection.
    # */
    SDIF_API SdifSelectionT *SdifCreateSelection (void)
    # 
    # /*DOC: 
    # */
    SDIF_API int SdifInitSelection (SdifSelectionT *sel, const_char_ptr filename, int namelen)
    # 
    # /*DOC: 
    # */
    SDIF_API int SdifFreeSelection (SdifSelectionT *sel)
    # 
    # /*DOC:
    #   Killer function for SdifKillList: free one SdifSelectElement 
    # */
    # SDIF_API void SdifKillSelectElement (/*SdifSelectionT*/ void *victim);
    # 
    # 
    # 
    # /*
    # // FUNCTION GROUP:      Parse and Set Selection
    # */
    # 
    # 
    # /*DOC: 
    #   Returns pointer to first char of select spec (starting with ::), 
    #   or NULL if not found.
    # */
    SDIF_API char *SdifSelectFindSelection (const_char_ptr filename)
    # 
    # 
    # /*DOC: 
    # */
    #  SDIF_API char *SdifGetFilenameAndSelection (/*in*/  const_char_ptr filename, 
    #                                             /*out*/ SdifSelectionT *sel);
    SDIF_API char *SdifGetFilenameAndSelection (const_char_ptr filename, 
                                                SdifSelectionT *sel)
    # 
    # /*DOC: 
    #   Replace current selection by new one given in first argument.
    #   The selection specification may contain all the parts of a filename
    #   based selection after the  selection indicator :: .
    # */
    # SDIF_API void SdifReplaceSelection (/*in*/ const char* selectionstr,
    #                            /*out*/ SdifSelectionT *sel);
    SDIF_API void SdifReplaceSelection (const_char_ptr selectionstr,
                                        SdifSelectionT *sel)
    # 
    # 
    # /*DOC: 
    # */
    SDIF_API void SdifPrintSelection (FILE *out, SdifSelectionT *sel, int options);
    # 
    # 
    # 
    # /*DOC:
    #   Parse comma-separated list of signatures into list of SdifSelectElementT
    #   [Return] true if ok 
    # 
    #   List has to be created before with
    #         list = SdifCreateList (SdifKillSelectElement)
    # */
    SDIF_API int SdifParseSignatureList (SdifListT *list, const_char_ptr str);
    # 
    # 
    # 
    # /*
    # // FUNCTION GROUP:      Add Selections to Element Lists
    # */
    # 
    # /* Give documentation and fake prototype for _add... macro generated functions.
    #    Cocoon ignores the #if 0.
    # */
    # #if 0
    # 
    # /*DOC:
    #   Create and add one value to selection element list.  There are four 
    #   functions generated automatically, with the meta type-variables _type_ and 
    #   _datatype_:
    #   [] _type_ is one of:  <br> Int, Real,   Signature,     String, for
    #   [] _datatype_ of:     <br> int, double, SdifSignature, char *, respectively.
    # */
    # void SdifSelectAdd_TYPE_ (SdifListT *list, _datatype_ value);
    # 
    # /*DOC:
    #   Create and add one range to selection element list.  There are four 
    #   functions generated automatically, with the meta type-variables _type_ and 
    #   _datatype_:
    #   [] _type_ is one of:  <br> Int, Real,   Signature,     String, for
    #   [] _datatype_ of:     <br> int, double, SdifSignature, char *, respectively.
    # 
    #   Example: to add the time range (t1, t2) to the selection in file, call
    #         SdifSelectAddRealRange(file->Selection->time, t1, sst_range, t2);
    # */
    # void SdifSelectAdd_TYPE_Range (SdifListT *list, 
    #                                _datatype_ value, 
    #                                SdifSelectTokens rt, 
    #                                _datatype_ range);
    # 
    # #endif  /* if 0 */
    # 
    # 
    # #define _addrangeproto(name, type, field) \
    # SDIF_API void SdifSelectAdd##name##Range (SdifListT *list, \
    #                                  type value, SdifSelectTokens rt, type range)
    # 
    # #define _addsimpleproto(name, type, field) \
    # SDIF_API void SdifSelectAdd##name (SdifListT *list, type value)
    # 
    # #define _addproto(name, type, field) \
    # _addsimpleproto (name, type, field); \
    # _addrangeproto  (name, type, field);
    # 
    # _addproto (Int,       int,              integer)
    # _addproto (Real,      double,           real)
    # _addproto (Signature, SdifSignature,    signature)
    # _addproto (String,    char *,           string)
    SDIF_API void SdifSelectAddInt (SdifListT *list, int value)
    SDIF_API void SdifSelectAddIntRange (SdifListT *list, int value, SdifSelectTokens rt, int range)
    SDIF_API void SdifSelectAddReal (SdifListT *list, double value)
    SDIF_API void SdifSelectAddRealRange (SdifListT *list, double value, SdifSelectTokens rt, double range)
    SDIF_API void SdifSelectAddSignature (SdifListT *list, SdifSignature value)
    SDIF_API void SdifSelectAddSignatureRange (SdifListT *list, SdifSignature value, SdifSelectTokens rt, SdifSignature range)
    SDIF_API void SdifSelectAddString (SdifListT *list, char * value)
    SDIF_API void SdifSelectAddStringRange (SdifListT *list, char * value, SdifSelectTokens rt, char* range)
    
    # 
    # 
    # /*DOC: 
    #   copy a selection list source, appending to an existing one dest
    #   the same but freshly allocated elements from source
    # 
    #   @return dest
    # */
    # SDIF_API SdifListT *SdifSelectAppendList (SdifListT *dest, SdifListT *source);
    # 
    # /*DOC:
    #   convert list of int selections to mask 
    # 
    #   do this whenever elements have been added to an int selection list
    # */
    SDIF_API void SdifSelectGetIntMask (SdifListP list, SdifSelectIntMaskP mask)
    # 
    # 
    # 
    # 
    # /*
    # // FUNCTION GROUP:      Query parsed ranges (list of ranges).
    # */
    # 
    # /*DOC:
    #   Query parsed ranges (list of ranges) for a selection element (one of
    #   the SdifListP lists in SdifSelectionT).  Init list traversal with
    #   SdifListInitLoop, then call SdifSelectGetNext<type>(list) until it
    #   returns 0.
    # 
    #   The number of selections in the list is SdifListGetNbData(list), if
    #   it is 0, or SdifListIsEmpty(list) is true, then there was no
    #   selection for that element.
    # 
    #   If force_range is 1, the out value is converted to a range in any
    #   case, with value <= range guaranteed.  
    # */
    # SDIF_API int SdifSelectGetNextIntRange  (/*in*/  SdifListP list, 
    #                                 /*out*/ SdifSelectElementIntT  *range, 
    #                                 /*in*/  int force_range);
    SDIF_API int SdifSelectGetNextIntRange  (SdifListP list, 
                                             SdifSelectElementIntT  *range, 
                                             int force_range)
    #
    
    # 
    # /*DOC: 
    #   See SdifSelectGetNextInt.
    # */
    # SDIF_API int SdifSelectGetNextRealRange (/*in*/  SdifListP list, 
    #                                 /*out*/ SdifSelectElementRealT *range, 
    #                                 /*in*/  int force_range);
    SDIF_API int SdifSelectGetNextRealRange (SdifListP list, 
                                             SdifSelectElementRealT *range, 
                                             int force_range)
    
    # 
    # /*DOC: 
    #   Query list of parsed selection elements (one of the SdifListP
    #   lists in SdifSelectionT).  Init list traversal with
    #   SdifListInitLoop, then call SdifSelectGetNext<type>(list) until it
    #   returns 0.
    # 
    #   See also SdifSelectGetNextInt.  
    # */
    # SDIF_API SdifSignature  SdifSelectGetNextSignature (/*in*/  SdifListP list);
    SDIF_API SdifSignature  SdifSelectGetNextSignature (SdifListP list)
    # 
    # /*DOC: 
    #   See SdifSelectGetNextSignature.
    # */
    # SDIF_API char          *SdifSelectGetNextString    (/*in*/  SdifListP list);
    SDIF_API char *SdifSelectGetNextString (SdifListP list)
    # 
    # 
    # /*DOC: 
    #   Return value of first selection (ignoring range).
    # */
    SDIF_API int            SdifSelectGetFirstInt       (SdifListP l, int defval)
    SDIF_API double         SdifSelectGetFirstReal      (SdifListP l, double defval)
    SDIF_API char *         SdifSelectGetFirstString    (SdifListP l, char *defval)
    SDIF_API SdifSignature  SdifSelectGetFirstSignature (SdifListP l, SdifSignature defval)
    # 
    # 
    # 
    # 
    # 
    # /*
    # // FUNCTION GROUP:      Selection Testing Functions
    # */
    # 
    SDIF_API int SdifSelectTestIntMask (SdifSelectIntMaskT *mask, SdifUInt4 cand)
    # 
    SDIF_API int SdifSelectTestIntRange  (SdifSelectElementT *elem, SdifUInt4 cand)
    SDIF_API int SdifSelectTestRealRange (SdifSelectElementT *elem, double cand)
    # 
    SDIF_API int SdifSelectTestInt (SdifListT *list, SdifUInt4 cand)
    SDIF_API int SdifSelectTestReal (SdifListT *list, double cand)
    ctypedef SdifSignature const_SdifSignature "const SdifSignature"
    SDIF_API int SdifSelectTestSignature (SdifListT *list, const_SdifSignature cand)
    SDIF_API int SdifSelectTestString (SdifListT *list, const_char_ptr cand)
    # 
    # 
    # 
    # /*
    # // FUNCTION GROUP:      Using a Selection in File I/O.
    # */
    # 
    # 
    # /*DOC:
    #   Get number of selected streams in file selection, 0 for all  */
    SDIF_API int SdifFNumStreamsSelected (SdifFileT *file)
    # 
    # /*DOC: 
    #   Get number of selected rows in file selection, or num rows in
    #   current matrix when all are selected.
    #   SdifFReadMatrixHeader must have been called before! */
    SDIF_API int SdifFNumRowsSelected (SdifFileT *file)
    # 
    # /*DOC:
    #   Get number of selected columns in file selection, or num columns in
    #   current matrix when all are selected  
    #   SdifFReadMatrixHeader must have been called before! */
    SDIF_API int SdifFNumColumnsSelected (SdifFileT *file)
    # 
    # /*DOC: 
    #   Read frame headers until a frame matching the file selection
    #   has been found or the end of the file has been reached.
    # 
    #   [Return] false if end of file was reached, true if data has been read. */
    SDIF_API int SdifFReadNextSelectedFrameHeader (SdifFileT *f)
    # 
    # 
    # 
    # /*DOC: 
    #   Test the selection elements from sel applicable to frame FramH:
    #   time, stream, frame type. */
    SDIF_API int SdifFrameIsSelected (SdifFrameHeaderT *FramH, SdifSelectionT *sel)
    # 
    # /*DOC:
    #   Test the selection elements from sel applicable to matrix MtrxH: 
    #   the matrix signature. */
    SDIF_API int SdifMatrixIsSelected (SdifMatrixHeaderT *MtrxH, SdifSelectionT *sel)
    # 
    # 
    # /*DOC: 
    #   Test if the current frame header is in the file selection
    #   (automatically parsed from the filename).  
    #   Can be called after SdifFReadFrameHeader(). */
    SDIF_API int SdifFCurrFrameIsSelected (SdifFileT *file)
    # 
    # /*DOC:
    #   Test if the current matrix header is in the file selection
    #   (automatically parsed from the filename).  
    #   Can be called after SdifFReadMatrixHeader(). */
    SDIF_API int SdifFCurrMatrixIsSelected (SdifFileT *file)
    # 
    # /*DOC:
    #   Test file selection if a given row (starting from 1) is selected */
    SDIF_API int SdifFRowIsSelected (SdifFileT *file, int row)
    # 
    # /*DOC:
    #   Test file selection if a given column (starting from 1) is selected */
    SDIF_API int SdifFColumnIsSelected (SdifFileT *file, int col)
    # 
    # 
    # 
    # 
    # /*
    # // FUNCTION GROUP:      Handling of a Table of Signatures
    # */
    # 
    # /*DOC:
    #   Create table for initially NbSignMax signatures. */
    ctypedef SdifUInt4 const_SdifUInt4 "const SdifUInt4"
    SDIF_API SdifSignatureTabT* SdifCreateSignatureTab (const SdifUInt4 NbSignMax)
    # 
    # /*DOC:
    #   Free signature table. */
    SDIF_API void               SdifKillSignatureTab   (SdifSignatureTabT *SignTab)
    # 
    # /*DOC:
    #   Reallocate table to hold NewNbSignMax signatures. */
    SDIF_API SdifSignatureTabT* SdifReAllocSignatureTab(SdifSignatureTabT *SignTab, 
                                                const_SdifUInt4 NewNbSignMax)
    # 
    # /*DOC:
    #   Reallocate table to hold NewNbSignMax signatures and clear signatures. */
    SDIF_API SdifSignatureTabT* SdifReInitSignatureTab (SdifSignatureTabT *SignTab, 
                                                const_SdifUInt4 NewNbSignMax)
    # 
    # /*DOC:
    #   Add signature Sign, no overflow check. */
    SDIF_API SdifSignatureTabT* SdifPutInSignatureTab  (SdifSignatureTabT *SignTab, 
                                                const_SdifSignature Sign)
    # 
    # /*DOC:
    #   Add signature Sign, reallocate table if necessary. */
    SDIF_API SdifSignatureTabT* SdifAddToSignatureTab  (SdifSignatureTabT *SignTab, 
                                                const_SdifSignature Sign)
    # 
    # /*DOC:
    #   Get signature at position index.  
    #   Returns eEmptySignature if index out of bounds. */
    SDIF_API SdifSignature      SdifGetFromSignatureTab(const_SdifSignatureTabT_ptr SignTab, 
                                                const_int index)
    # 
    # /*DOC:
    #   Test if signature Sign is in table SignTab. 
    #   [] Returns Sign if yes, 0 (== eEmptySignature) if no. */
    SDIF_API SdifSignature      SdifIsInSignatureTab   (const_SdifSignatureTabT_ptr SignTab, 
                                               const_SdifSignature Sign)
    # 
    # /*DOC:
    #   Test if signature Sign is in table SignTab. 
    #   [] Returns index of Sign if yes, -1 if no. */
    SDIF_API int                SdifFindInSignatureTab (const_SdifSignatureTabT_ptr SignTab, 
                                                const_SdifSignature Sign)
    # 
    # 
    # 
    # 
    # 
    # 
    # /*
    # // DATA GROUP:          Stream ID Table and Entries for 1IDS ASCII chunk
    # */
    # 
    # 
    SDIF_API SdifStreamIDT* SdifCreateStreamID(SdifUInt4 NumID, char *Source, char *TreeWay
    SDIF_API void           SdifKillStreamID(SdifStreamIDT *StreamID)
    # 
    # 
    # /*DOC:
    #   Create a stream ID table.  <strong>The stream ID table of the SDIF
    #   file structure is created automatically by SdifFOpen().</strong> 
    #   It can be obtained by SdifFStreamIDTable(). */
    SDIF_API SdifStreamIDTableT* SdifCreateStreamIDTable     (SdifUInt4 HashSize)
    # 
    # /*DOC:
    #   Deallocate a stream ID table.  <strong>The stream ID table of the SDIF
    #   file structure is killed automatically by SdifFClose.</strong>  
    #   It can be obtained by SdifFStreamIDTable. */
    SDIF_API void                SdifKillStreamIDTable       (SdifStreamIDTableT *SIDTable)
    # 
    # /*DOC:
    #   Add an entry to a stream ID table.  The table will be written by
    #   SdifFWriteAllASCIIChunks.
    #   [in]  SIDTable pointer to stream ID table, e.g. obtained by SdifFStreamIDTable
    #   [in]  NumID   stream ID of the frames the stream ID table describes
    #   [in]  Source  Source identifier for the table (ex. "Chant")
    #   [in]  TreeWay Routing and parameters, separated by slashes
    #   [return]
    #                 The stream ID table entry just created and added */
    SDIF_API SdifStreamIDT*      SdifStreamIDTablePutSID     (SdifStreamIDTableT *SIDTable,
                                                      SdifUInt4           NumID, 
                                                      char               *Source, 
                                                      char               *TreeWay)
    # 
    # /*DOC:
    #   Retrieve an entry to a stream ID table.  The table has to have been
    #   read by SdifFReadAllASCIIChunks.
    # 
    #   [in]  SIDTable pointer to stream ID table, e.g. obtained by 
    #                  SdifFStreamIDTable
    #   [in]  NumID    stream ID of the frames the stream ID table describes
    #   [return]
    #                  pointer to stream ID table entry, or NULL if no entry for 
    #                  stream ID NumID exists. */
    SDIF_API SdifStreamIDT*      SdifStreamIDTableGetSID     (SdifStreamIDTableT *SIDTable, 
                                                      SdifUInt4           NumID)
    # 
    # /*DOC:
    #   Return number of entries in stream ID table SIDTable */
    SDIF_API SdifUInt4           SdifStreamIDTableGetNbData  (SdifStreamIDTableT *SIDTable)
    # 
    # 
    # /*DOC:
    #   Return stream ID field in stream ID table entry SID */
    SDIF_API SdifUInt4           SdifStreamIDEntryGetSID     (SdifStreamIDT *SID)
    # 
    # /*DOC:
    #   Return source field in stream ID table entry SID */
    SDIF_API char               *SdifStreamIDEntryGetSource  (SdifStreamIDT *SID)
    # 
    # /*DOC:
    #   Return "treeway" field in stream ID table entry SID */
    SDIF_API char               *SdifStreamIDEntryGetTreeWay (SdifStreamIDT *SID)
    # 
    # 
    # 
    # 
    # /*
    # //FUNCTION GROUP: Sdif String Handling
    # */
    # 
    # /* SdifString.h */
    # 
    # /* Function declaration */
    # 
    # /*DOC:
    #   Make a memory allocation for a SdifStringT structure.
    # */
    SDIF_API SdifStringT * SdifStringNew(void)
    # 
    # 
    # /*DOC:
    #   Free memory allocated for SdifString.
    # */
    SDIF_API void SdifStringFree(SdifStringT * SdifString)
    # 
    # 
    # /*DOC:
    #   Append a string to another one.
    #   Manage memory reallocation.
    #   [Return] a boolean for the succes of the function's call.
    # */
    SDIF_API int SdifStringAppend(SdifStringT * SdifString, const_char_ptr strToAppend)
    # 
    # 
    # /*DOC:
    #   Read the current char (= fgetc).
    # */
    SDIF_API int SdifStringGetC(SdifStringT * SdifString)
    # 
    # 
    # /*DOC:
    #   Equivalent of ungetc: put one character back into string, clear EOS condition
    # */
    SDIF_API int SdifStringUngetC(SdifStringT * SdifString)
    # 
    # 
    # /*DOC:
    #   Test the end of the string (= feof)
    # */
    SDIF_API int SdifStringIsEOS(SdifStringT *SdifString)
    # 
    # 
    # 
    # /*
    # typedef enum SdifInterpretationErrorE
    # {
    #   eTypeDataNotSupported= 300,
    #   eNameLength,
    #   eReDefined,
    #   eUnDefined,
    #   eSyntax,
    #   eRecursiveDetect,
    #   eBadTypesFile,
    #   eBadType,
    #   eBadHeader,
    #   eOnlyOneChunkOf,
    #   eUnInterpreted,
    #   eUserDefInFileYet,
    #   eBadMode,
    #   eBadStdFile,
    #   eBadNbData,
    #   eReadWriteOnSameFile
    # } SdifInterpretationErrorET;
    # 
    # 
    # 
    # void
    # SdifInterpretationError(SdifInterpretationErrorET Error, SdifFileT* SdifF, const void *ErrorMess);
    # 
    # #define _SdifFileMess(sdiff, error, mess) \
    # (SdifErrorFile = __FILE__, SdifErrorLine = __LINE__, SdifInterpretationError((error), (sdiff),(mess)))
    # 
    # */
    # 
    # #define _SdifFileMess(sdiff, error, mess) 
    # 
    # /*DOC: 
    #   Cette fonction vérifie si le type de matrice est répertorié
    #   dans SdifF.<br> S'il ne l'est pas, alors elle vérifie si c'est un
    #   type prédéfinis. S'il est prédéfini, elle crée le lien de SdifF vers
    #   le type prédéfini. Sinon, elle envoie un message sur l'erreur
    #   standart.  */
    SDIF_API SdifMatrixTypeT* SdifTestMatrixType (SdifFileT *SdifF, SdifSignature Signature)
    SDIF_API SdifFrameTypeT*  SdifTestFrameType  (SdifFileT *SdifF, SdifSignature Signature)
    # 
    # 
    # 
    SDIF_API int SdifFTestMatrixWithFrameHeader (SdifFileT* SdifF)
    SDIF_API int SdifFTestDataType              (SdifFileT* SdifF)
    SDIF_API int SdifFTestNbColumns             (SdifFileT* SdifF)
    SDIF_API int SdifFTestNotEmptyMatrix        (SdifFileT* SdifF)
    SDIF_API int SdifFTestMatrixHeader          (SdifFileT* SdifF)
    # 
    # 
    # 
    SDIF_API SdifColumnDefT*  SdifTestColumnDef (SdifFileT *SdifF, SdifMatrixTypeT *MtrxT, const_char_ptr NameCD)
    SDIF_API SdifComponentT*  SdifTestComponent (SdifFileT* SdifF, SdifFrameTypeT *FramT, const_char_ptr NameCD)
    # 
    SDIF_API int SdifTestSignature            (SdifFileT *SdifF, int CharEnd, SdifSignature Signature, const_char_ptr Mess)
    SDIF_API int SdifTestCharEnd              (SdifFileT *SdifF, int CharEnd, char MustBe,
                                               char *StringRead, int ErrCondition, const_char_ptr Mess)
    # 
    # 
    SDIF_API int SdifTestMatrixTypeModifMode  (SdifFileT *SdifF, SdifMatrixTypeT *MatrixType)
    SDIF_API int SdifTestFrameTypeModifMode   (SdifFileT *SdifF, SdifFrameTypeT *FrameType)
    # 
    # 
    # 
    SDIF_API size_t SdifFTextConvMatrixData     (SdifFileT *SdifF)
    SDIF_API size_t SdifFTextConvMatrix         (SdifFileT *SdifF)
    SDIF_API size_t SdifFTextConvFrameData      (SdifFileT *SdifF)
    SDIF_API size_t SdifFTextConvFrameHeader    (SdifFileT *SdifF)
    SDIF_API size_t SdifFTextConvFrame          (SdifFileT *SdifF)
    SDIF_API size_t SdifFTextConvAllFrame       (SdifFileT *SdifF)
    SDIF_API size_t SdifFTextConvFramesChunk    (SdifFileT *SdifF)
    SDIF_API size_t SdifFTextConv               (SdifFileT *SdifF)
    # 
    # /* upper level : open the text in read mode */
    # 
    # /*DOC: 
    #   Converti un fichier SDIF ouvert en lecture (eReadFile) en un fichier
    #   texte pseudo-SDIF de nom TextStreamName.  */
    SDIF_API size_t SdifTextToSdif (SdifFileT *SdifF, char *TextStreamName)
    # 
    # 
    # 
    # 
    # /* SdifFPrint */
    # 
    SDIF_API size_t SdifFPrintGeneralHeader      (SdifFileT *SdifF)
    SDIF_API size_t SdifFPrintNameValueLCurrNVT  (SdifFileT *SdifF)
    SDIF_API size_t SdifFPrintAllNameValueNVT    (SdifFileT *SdifF
    SDIF_API size_t SdifFPrintAllType            (SdifFileT *SdifF)
    SDIF_API size_t SdifFPrintAllStreamID        (SdifFileT *SdifF)
    SDIF_API size_t SdifFPrintAllASCIIChunks     (SdifFileT *SdifF)
    SDIF_API size_t SdifFPrintMatrixHeader       (SdifFileT *SdifF)
    SDIF_API size_t SdifFPrintFrameHeader        (SdifFileT *SdifF)
    SDIF_API size_t SdifFPrintOneRow             (SdifFileT *SdifF)
    # 
    SDIF_API size_t SdifFPrintMatrixType         (SdifFileT *SdifF, SdifMatrixTypeT *MatrixType)
    SDIF_API size_t SdifFPrintFrameType          (SdifFileT *SdifF, SdifFrameTypeT  *FrameType)
    # 
    # /* SdifFPut */
    # 
    SDIF_API int SdifFAllFrameTypeToSdifString   (SdifFileT *SdifF, SdifStringT *SdifString)
    SDIF_API int SdifFAllMatrixTypeToSdifString  (SdifFileT *SdifF, SdifStringT *SdifSTring)
    # 
    # #ifdef __cplusplus
    # }
    # #endif
    # 
    # #endif /* _SDIF_H */
