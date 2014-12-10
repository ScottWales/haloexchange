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
    integer, parameter :: ndims = 2

    type, public :: communicator
        integer mpi_comm
    contains
        procedure :: valid
    end type

    type, public, extends(communicator) :: cartesian_communicator
        integer :: size(ndims)
        logical :: periodic(ndims)
    end type

    interface cartesian_communicator
        procedure new_cartesian_comm_world
    end interface

contains

    ! Create a 2D cartesian communicator from WORLD
    !
    ! Call like
    !     comm = cartesian_communicator()
    !
    function new_cartesian_comm_world() result(this)
        use mpi
        type(cartesian_communicator) :: this

        integer, parameter :: ndims = 2
        logical :: reorder
        integer :: ierr

        this%size     = 1
        this%periodic = .true.
        reorder       = .true.

        call MPI_Cart_create(MPI_COMM_WORLD, &
                             ndims,          &
                             this%size,      &
                             this%periodic,   &
                             reorder,        &
                             this%mpi_comm,  &
                             ierr)
    end function

    ! Check if the communicator is valid (i.e. this process is a member)
    function valid(this)
        use mpi

        class(communicator), intent(in) :: this
        logical valid

        valid = this%mpi_comm .ne. MPI_COMM_NULL
    end function

end module
