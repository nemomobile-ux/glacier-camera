%{!?qtc_qmake:%define qtc_qmake %qmake}
%{!?qtc_qmake5:%define qtc_qmake5 %qmake5}
%{!?qtc_make:%define qtc_make make}
%{?qtc_builddir:%define _builddir %qtc_builddir}

Name:       glacier-camera
Summary:    Glacier Camera
Version:    0.1.1
Release:    2
Group:      Qt/Qt
License:    LGPL
URL:        https://github.com/nemomobile-ux/glacier-camera
Source0:    %{name}-%{version}.tar.bz2
Requires:   qt5-qtquickcontrols-nemo
Requires:   nemo-qml-plugin-settings
Requires:   libglacierapp
Requires:   mapplauncherd-booster-nemomobile

BuildRequires:  cmake
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  pkgconfig(glacierapp)
BuildRequires:  desktop-file-utils
%if 0%{?fedora}
%define lrelease lrelease-qt5
BuildRequires:  qt5-linguist
%else
%define lrelease lrelease
BuildRequires:  qt5-qttools-linguist
%endif

%description
Settings application for nemo mobile

%prep
%setup -q -n %{name}-%{version}

%build
mkdir build
cd build
cmake \
	-DCMAKE_BUILD_TYPE=None \
	-DCMAKE_INSTALL_PREFIX=%{_prefix} \
	-DCMAKE_VERBOSE_MAKEFILE=ON \
	..
cmake --build .

%install
cd build
rm -rf %{buildroot}
DESTDIR=%{buildroot} cmake --build . --target install

%files
%defattr(-,root,root,-)
%{_bindir}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
