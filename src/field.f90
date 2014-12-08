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
    private
    
    type, public :: field
        integer :: comm !< MPI communicator

        integer :: grid_size !< We assume a square grid
        integer :: halo_size

        real, allocatable :: local_data(:,:)
    contains
        procedure :: sync
    end type

    interface field
        procedure :: new_field
    end interface

contains

    function new_field(size, halo, comm) result(this)
        integer, intent(in) :: comm ! A cartesian communicator
        integer, intent(in) :: size, halo
        type(field) :: this

        this%comm = comm
        this%grid_size = size
        this%halo_size = halo

        call allocate_local_data(this)
    end function

    subroutine allocate_local_data(this)
        type(field), intent(inout) :: this

        integer :: min, max

        ! If halo=0 then min=1
        min = -this%halo_size + 1
        max =  this%grid_size + this%halo_size

        allocate(this%local_data(min:max,min:max))
    end subroutine

    subroutine sync(this)
        class(field), intent(inout) :: this

    end subroutine

end module