!> \file    src/haloexchange.f90
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

program haloexchange
    use mpi
    use mpi_helper_mod
    use field_mod

    integer     :: ierr
    type(field) :: temperature
    type(cartesian_communicator)  :: comm

    call MPI_Init(ierr)

    ! First create a cartesian communicator
    comm = cartesian_communicator()
    if (comm%valid()) then

        ! Now create a field on the communicator
        temperature = field(2048,20,comm)

        ! Syncronise the field across processors
        call temperature%sync()

    end if
    call MPI_Finalize(ierr)
end program
