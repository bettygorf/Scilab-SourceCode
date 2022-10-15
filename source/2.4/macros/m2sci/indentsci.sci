function [txt]=indentsci(txt)
//
//!
// Copyright INRIA
bl='  '
txt=bl(ones(prod(size(txt)),1))+txt



