%{!?qtc_qmake:%define qtc_qmake %qmake}
%{!?qtc_qmake5:%define qtc_qmake5 %qmake5}
%{!?qtc_make:%define qtc_make make}
%{?qtc_builddir:%define _builddir %qtc_builddir}

Name:       glacier-camera
Summary:    Glacier Camera
Version:    0.1
Release:    1
Group:      Qt/Qt
License:    LGPL
URL:        https://github.com/nemomobile-ux/glacier-camera
Source0:    %{name}-%{version}.tar.bz2
Requires:   qt5-qtquickcontrols-nemo
Requires:   nemo-qml-plugin-settings

BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  desktop-file-utils

%description
Settings application for nemo mobile

%prep
%setup -q -n %{name}-%{version}

%build
%qtc_qmake5  VERSION=%{version}

make %{?_smp_mflags}

%install
rm -rf %{buildroot}
%qmake5_install

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_bindir}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
