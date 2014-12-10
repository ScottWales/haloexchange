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
    use :: mpi_f08, only: MPI_Comm

    private

    integer, parameter :: ndims = 2

    type, public :: communicator
        type(MPI_Comm) :: mpi_comm
        integer   :: rank
    contains
        procedure :: valid
        procedure :: isend
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
        use mpi_f08
        type(cartesian_communicator) :: this

        integer, parameter :: ndims = 2
        logical :: reorder
        integer :: ierr

        this%periodic(:) = .true.
        reorder          = .true.

        call cart_size(this, MPI_COMM_WORLD)

        call MPI_Cart_create(MPI_COMM_WORLD, &
                             ndims,          &
                             this%size,      &
                             this%periodic,   &
                             reorder,        &
                             this%mpi_comm,  &
                             ierr)
        call MPI_Comm_rank(this%mpi_comm, this%rank, ierr)
    end function

    ! Check if the communicator is valid (i.e. this process is a member)
    function valid(this)
        use mpi_f08

        class(communicator), intent(in) :: this
        logical valid

        valid = this%mpi_comm .ne. MPI_COMM_NULL
    end function

    ! Set the size of `this` to fit within the processes of `comm`
    ! Just use a square as a test
    subroutine cart_size(this, comm)
        use mpi_f08
        use error_mod

        class(cartesian_communicator), intent(inout) :: this
        type(MPI_Comm), intent(in) :: comm

        integer :: comm_size
        integer :: ierr
        integer :: side

        call MPI_Comm_size(comm, comm_size, ierr)

        side = floor(sqrt(real(comm_size)))

        call assert(side*side .le. comm_size, &
            'side^2 should be <= comm_size')

        this%size(:) = side
    end subroutine

    ! Send data in `buf` to process rank `dest`
    ! The message is tagged with the rank of the sending process
    subroutine isend(this, buf, dest, request)
        use mpi_f08
        class(communicator), intent(inout) :: this
        real,                intent(in)    :: buf(:,:)
        integer,             intent(in)    :: dest
        type(MPI_Request),   intent(out)   :: request

        call MPI_ISend(buf, size(buf), MPI_REAL, &
                       dest, this%rank,          &
                       this%mpi_comm, request)
    end subroutine

end module
