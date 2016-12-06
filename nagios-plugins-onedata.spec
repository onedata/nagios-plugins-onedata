%define dir %{_libdir}/nagios/plugins/onedata

Summary: Nagios plugins for Onedata services
Name: nagios-plugins-onedata
Version: 3.0.0
Release: 2%{?dist}
License: ASL 2.0
Group: Network/Monitoring
Source0: %{name}-%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
BuildArch: noarch
Requires: curl
Requires: xmllint
%description

%prep
%setup -q

%build

%install
rm -rf $RPM_BUILD_ROOT
install --directory ${RPM_BUILD_ROOT}%{dir}
install --mode 755 src/*  ${RPM_BUILD_ROOT}%{dir}

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%{dir}

%changelog
* Wed Dec 07 2016 Bartosz Kryza <bkryza@agh.edu.pl> - 3.0.0-2%{?dist}
- Initial implementation