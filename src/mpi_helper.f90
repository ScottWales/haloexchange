!> \file    src/mpi_helper.f90
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

module mpi_helper_mod
    private

    ! Namespace
    type :: mpi_helper_namespace
    contains
        procedure, nopass :: cartesian
    end type
    type(mpi_helper_namespace), public :: mpi_helper

contains

    ! Create a 2D cartesian communicator from WORLD
    function cartesian() result(comm)
        use mpi
        integer :: comm

        integer, parameter :: ndims = 2
        integer :: dims(ndims)
        logical :: periods(ndims)
        logical :: reorder
        integer :: ierr

        dims    = 1
        periods = .true.
        reorder = .true.

        call MPI_Cart_create(MPI_COMM_WORLD, &
                             ndims,          &
                             dims,           &
                             periods,        &
                             reorder,        &
                             comm,           &
                             ierr)
    end function

end module
