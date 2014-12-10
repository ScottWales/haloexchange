!> \file    src/field.f90
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

module field_mod
    use mpi_helper_mod
    private
    
    type, public :: field
        type(cartesian_communicator) :: comm !< MPI communicator

        integer :: grid_size !< We assume a square grid
        integer :: halo_size

        real, allocatable :: local_data(:,:)
    contains
        procedure :: sync
    end type

    interface field
        procedure :: new_field_square
    end interface

contains

    ! Construct a new 2D scalar field with a given size. The field is assumed to
    ! be square, with the storage distributed across all the processers in comm.
    !
    ! Call like
    !    temperature = field(2048, 20 , comm)
    !
    function new_field_square(size, halo, comm) result(this)
        integer, intent(in) :: size, halo
        type(cartesian_communicator), intent(in) :: comm
        type(field) :: this

        this%comm = comm
        this%grid_size = size
        this%halo_size = halo

        call allocate_local_data(this)
    end function

    ! Helper function to handle allocations
    subroutine allocate_local_data(this)
        use error_mod

        type(field), intent(inout) :: this

        integer :: min, max        

        call assert(this%comm%size(1) .eq. this%comm%size(2), &
            'Communicator should be square')

        ! If halo=0 then min=1
        min = -this%halo_size + 1
        max =  this%grid_size + this%halo_size

        allocate(this%local_data(min:max,min:max))
    end subroutine

    ! Exchange halo data between processes
    !
    ! Call like
    !    call temperature%sync()
    !
    subroutine sync(this)
        class(field), intent(inout) :: this

    end subroutine

end module
