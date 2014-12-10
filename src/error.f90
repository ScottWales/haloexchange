!> \file    src/error.f90
!! \author  Scott Wales <scott.wales@unimelb.edu.au>
!!
!! Copyright 2014 ARC Centre of Excellence for Climate Systems Science
!!
!! Licensed under the Apache License, Version 2.0 (the "License");
!! you may not use this file except in compliance with the License.
!! You may obtain a copy of the License at
!!
!!     http://www.apache.org/licenses/LICENSE-2.0
!!
!! Unless required by applicable law or agreed to in writing, software
!! distributed under the License is distributed on an "AS IS" BASIS,
!! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
!! See the License for the specific language governing permissions and
!! limitations under the License.

! Useful functions for error handling
module error_mod
    private
    public :: assert
contains

    ! If `test` is false print `message` to stderr and terminate the program
    subroutine assert(test, message)
        use mpi
        logical,          intent(in) :: test
        character(len=*), intent(in) :: message
        integer :: ierr

        if (test) then
            return
        end if
    
        write(0,*) 'ASSERT ERROR: ',message

        call traceback()

        call MPI_Abort(MPI_COMM_WORLD, 1, ierr)
    end subroutine

#ifdef __INTEL_COMPILER
    ! Print a traceback and return (Available in gfortran as an extension)
    subroutine traceback
        use ifcore

        call tracebackqq(user_exit_code = -1)
    end subroutine
#endif
end module
