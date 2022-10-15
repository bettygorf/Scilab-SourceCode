function []=halt()
//halt() stops execution until something is entered in the keyboard.
//!
// Copyright INRIA
write(%io(2),'halt'),read(%io(1),1,1,'(a1)');






