function fprintf(fil,frmt,varargin)
// fprintf - Emulator of C language fprintf
//!
// Copyright INRIA
write(fil,sprintf(frmt,varargin(:)))
