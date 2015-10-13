//
//  devfs.h
//  GGHttpEngineDemo
//
//  Created by cn on 15/2/27.
//  Copyright (c) 2015年 cn. All rights reserved.
//

#ifndef _DEVFS_H
#define _DEVFS_H

#ifdef __cplusplus
extern "C"
{
#endif

#define GG_MAX_PATH                   1024

/*
**	File Handle type define 
*/
typedef void* GG_FILE_HANDLE;

/*
**	File macro define 
*/
#define GG_INVALID_FILE_HANDLE           ((GG_FILE_HANDLE)-1)

/**
 *	@brief   OpenMode for $devFS_openFile$. 
 *  
 *  @remark  none. 
 *  
 *  @see     #devFS_openFile#, #devFS_closeFile#
 */
typedef enum _gg_FileOpenMode_enum
{
	GG_FOPEN_CREATE,      // Create an empty file for writing. If the given file exists, its contents are destroyed.
	GG_FOPEN_READ,        // Open a file for reading. If the file does not exist or cannot be found, the fopen call fails.
	GG_FOPEN_WRITE,       // Open a file for reading and writing. If the file exists, the function opens it.
	                      // If the file does not exist, the function fails. 
	GG_FOPEN_APPEND,
	GG_FOPEN_READ_SEEK,   //this is same as r+
	GG_FOPEN_WRITE_SEEK,  //this is same as w+
	
} gg_FileOpenMode;

/**
 *	@brief   Seek Mode for $devFS_seek$. 
 *  
 *  @remark  none. 
 *  
 *  @see     #devFS_seek#
 */
typedef enum _gg_SeekMode_enum
{
	GG_SEEK_SET,    // Move the file pointer from the beginning of the file.
	GG_SEEK_CUR,    // Move the file pointer from the current position in the file
	GG_SEEK_END,    // Move the file pointer from the end of the file.

} gg_FileSeekMode;

/**
 *  @brief   This function create folder. 
 *
 *  @param   fileName   [I] Pointer to a null-terminated string that specifies the name of the folder object to create. 
 *  
 *  @return  If the function succeeds, the return value is TRUE. \
 *           If the function fails, FALSE;
 */
int devFS_createFolder(const char* folder);

/**
 *  @brief   This function remove folder. 
 *
 *  @param   fileName   [I] Pointer to a null-terminated string that specifies the name of the folder object to remove. 
 *  
 *  @return  If the function succeeds, the return value is TRUE. \
 *           If the function fails, FALSE;
*/
int devFS_removeFolder(const char* folder);
	
/**
 *  @brief   This function opens a file according to opening mode. 
 *
 *  @param   fileName   [I] Pointer to a null-terminated string that specifies the name of the file object to create or open. 
 *  @param   openMode   [I] Specifies the opening mode. 
 *  
 *  @return  If the function succeeds, the return value is a file handle. \
 *           If the function fails, the return value is $GG_INVALID_FILE_HANDLE$;
 *
 *  @note    When using $GG_FOPEN_CREATE$, the old file will be removed if it existed. 
 *           Binary mode should be used whenever we call this function to open a file.
 *  
 *  @see     #gg_FileOpenMode#, #devFS_closeFile#, #devFS_writeFile#, #devFS_readFile#, #devFS_seek#, #devFS_getFileLength#
 */
GG_FILE_HANDLE devFS_openFile(const char* fileName, gg_FileOpenMode openMode);
int devFS_isHandleValid(GG_FILE_HANDLE fh);
    
/**
 *  @brief   This function closes the file handle which is opened by $devFS_openFile$.
 *
 *  @param   fh   [I] The file handle to be closed.
 *  
 *  @return  If successful, the return value is nonzero. \
 *           Otherwise, the return value is zero. 
 *
 *  @note    none.
 *  
 *  @see     #devFS_openFile# 
 */
int  devFS_closeFile(GG_FILE_HANDLE fh);

/**
 *  @brief   This function reads data to buffer according to the size to be read.
 *
 *  @param   fh     [I] The file handle to be read.
 *  @param   buffer [I] Storage location for data.
 *  @param   size   [I] Size (bytes) to be read.
 *  
 *  @return  Function returns the number of full items actually read. which may 
 *           be less than count if an error occurs or if the end of the file is 
 *           encountered before reaching count. \
 *           If size or count is 0, fread returns 0 and the buffer contents are unchanged.
 *
 *  @note    none. 
 *  
 *  @see     #devFS_openFile#, #devFS_closeFile#, #devFS_writeFile#, #devFS_seek#, #devFS_getFileLength#
 */
unsigned int devFS_readFile(GG_FILE_HANDLE fh, void* buffer, unsigned int size);

/**
 *  @brief   This function saves buffer to a file according to the size to be written.
 *
 *  @param   fh     [I] The file handle to be write. 
 *  @param   buffer [I] Pointer to data to be written.
 *  @param   size   [I] Size (bytes) to be written.
 *  
 *  @return  Function returns the number of full items actually written, which may 
 *           be less than count if an error occurs. Also, if an error occurs, the 
 *           file-position indicator cannot be determined.
 *  
 *  @note    none. 
 *  
 *  @see     #devFS_openFile#, #devFS_closeFile#, #devFS_readFile#, #devFS_seek#, #devFS_getFileLength#
 */
unsigned int devFS_writeFile(GG_FILE_HANDLE fh, const void* buffer, unsigned int size);

/**
 *  @brief   This function moves the file pointer to a specified location.
 *
 *  @param   fh     [I] File handle ,it should have be opened by other function call.
 *  @param   offset [I] Number of bytes from origin.
 *  @param   origin [I] Initial position.
 *  
 *  @return  If successful, function returns 0. \n
 *           Otherwise, it returns a nonzero value. 
 *  
 *  @note    none. 
 *  
 *  @see     #gg_FileSeekMode#, #devFS_openFile#, #devFS_closeFile#, #devFS_readFile#, #devFS_writeFile#
 */
int devFS_seek(GG_FILE_HANDLE fh, int offset, gg_FileSeekMode origin);

/**
 *  @brief   This function gets a file's length in bytes.
 *
 *  @param   fileName [I] Pointer to a null-terminated string that specifies the name of the file to be checked.
 *  
 *  @return  If the function succeeds, the return value is the file size. \
 *           If the function fails, the return value is -1.
 *
 *  @note    none. 
 *  
 *  @see     #devFS_getFileLength# 
 */
int devFS_getFileSize(const char* fileName);

/**
 *  @brief   This function gets a file's length in bytes.
 *
 *  @param   fh [I] File handle, it should have be opened by other function call.
 *  
 *  @return  If the function succeeds, the return value is the file size. \
 *           If the function fails, the return value is -1.
 *
 *  @note    none. 
 *  
 *  @see     #devFS_getFileSize#, #devFS_openFile#, #devFS_closeFile#, #devFS_readFile#, #devFS_writeFile#
 */
unsigned int devFS_getFileLength(GG_FILE_HANDLE fh);

/**
 *  @brief   This function determines if a file of a particular name exists
 *           within the file system.
 *
 *  @param   fileName  [I] Pointer to a null-terminated string that specifies the name of the file to be checked.
 *  
 *  @return  Function return nonzero, If exist; \n
 *           Otherwise, it return zero. 
 *
 *  @note    none. 
 *  
 *  @see     #devFS_openFile#, #devFS_removeFile# 
 */
int devFS_fileExist(const char* fileName);

/**
 *  @brief   This function deletes a file. 
 *
 *  @param   fileName  [I] Pointer to a null-terminated string that specifies the name of the file to be deleted.
 *  
 *  @return  If successful, the return value is nonzero. 
 *           Otherwise, the return value is zero. 
 *
 *  @note    If the file exists, the file will been deleted; otherwise it do nothing. 
 *  
 *  @see     #devFS_openFile#, #devFS_fileExist#
 */
int devFS_removeFile(const char* fileName);


int devFS_rename(const char* source,const char* target);
	
int  devFS_flush(GG_FILE_HANDLE f);
    
void devFS_flushToFile(GG_FILE_HANDLE f);
	
typedef void* GG_DIR_HANDLE;

GG_DIR_HANDLE devFS_openDir(const char * dir);

void devFS_closeDir(GG_DIR_HANDLE dir);
	
const char * devFS_readDir(GG_DIR_HANDLE dir);
	
//If successful, the return value >=0. Otherwise return -1
int devFS_getPos(GG_FILE_HANDLE f);
    
const char* devFS_getDocumentDirectory(void);

#ifdef __cplusplus
  }
#endif

#endif
