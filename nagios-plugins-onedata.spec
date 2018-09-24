%define dir %{_libdir}/argo-monitoring/probes/org.onedata

Summary: Nagios plugins for Onedata services
Name: nagios-plugins-onedata
Version: 3.2.0
Release: 1%{?dist}
License: ASL 2.0
Group: Network/Monitoring
Source0: %{name}-%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
BuildArch: noarch
Requires: bash
Requires: curl
Requires: libxml2
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
* Sat Feb 11 2017 Emir Imamagic <eimamagi@srce.hr> - 3.2.0-1%{?dist}
- Exit gracefully in case of curl failure
* Thu Feb 02 2017 Emir Imamagic <eimamagi@srce.hr> - 3.1.0-1%{?dist}
- Changed probes to be CentOS 6 compatible
- Modified logic for ERROR state
* Wed Dec 07 2016 Bartosz Kryza <bkryza@agh.edu.pl> - 3.0.0-1%{?dist}
- Initial implementation
